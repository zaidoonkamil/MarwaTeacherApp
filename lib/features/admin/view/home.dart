import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/features/admin/view/lessons/custom_lesson.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/background.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/view/ads.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'lessons/add_courses.dart';
import 'lessons/add_video.dart';
import 'lessons/all_video.dart';


class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static int currentIndex = 0;
  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getAds(context: context, page: '1')
        ..getProfile(context: context)
        ..getCourses(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is UpdateLockSuccessState){
            showToastSuccess(
                text: 'تم التحديث',
                context: context);
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  ConditionalBuilder(
                      condition: cubit.profileModel != null,
                      builder: (c){
                        return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 24,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            '! مرحباا مجددا',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            cubit.profileModel!.name.toString(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8,),
                                      Image.asset('assets/images/Mask group (1).png'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 26,),
                                Column(
                                  children: [
                                    ConditionalBuilder(
                                      condition:cubit.ads.isNotEmpty,
                                      builder:(c){
                                        return Column(
                                          children: [
                                            CarouselSlider(
                                              items: cubit.ads.isNotEmpty
                                                  ? cubit.ads.expand((ad) => ad.images.map((imageUrl) => Builder(
                                                builder: (BuildContext context) {
                                                  DateTime dateTime = ad.createdAt;
                                                  String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      navigateTo(context, AdsUser(
                                                        tittle: ad.title,
                                                        desc: ad.description,
                                                        image: imageUrl,
                                                        time: formattedDate,
                                                      ));
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: Image.network(
                                                        "$url/uploads/$imageUrl",
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))).toList()
                                                  : [],
                                              options: CarouselOptions(
                                                height: 160,
                                                viewportFraction: 0.85,
                                                enlargeCenterPage: true,
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                reverse: true,
                                                autoPlay: true,
                                                autoPlayInterval: const Duration(seconds: 6),
                                                autoPlayAnimationDuration:
                                                const Duration(seconds: 1),
                                                autoPlayCurve: Curves.fastOutSlowIn,
                                                scrollDirection: Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  currentIndex=index;
                                                  cubit.slid();
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: List.generate(cubit.ads.length, (index) {
                                                return Container(
                                                  width: currentIndex == index ? 30 : 8,
                                                  height: 7.0,
                                                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: currentIndex == index
                                                        ? primaryColor
                                                        : Colors.white,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                      fallback: (c)=> Container(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, AddVideo());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Text('اضافة فيديو',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, AllVideo());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Text('عرض كل الفيديوات',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, AddCourses());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryColor,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Text('اضافة فصل جديد',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        ': الفصول',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12,),
                                cubit.coursesModel.isNotEmpty? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: GridView.custom(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 1,
                                      childAspectRatio: 0.8,
                                    ),
                                    childrenDelegate: SliverChildBuilderDelegate(
                                      childCount: cubit.coursesModel.length, (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          navigateTo(context, CustomLesson(courseId: cubit.coursesModel[index].id.toString()));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  cubit.deleteCourses(
                                                      id: cubit.coursesModel[index].id.toString(),
                                                      context: context);
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        color: Colors.red
                                                    ),
                                                    child: Icon(Icons.delete,color: Colors.white,)),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 14,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: Image.asset(
                                                              'assets/images/Logo.png',
                                                              width: 90,
                                                              height: 90,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  cubit.coursesModel[index].title,
                                                                  style: TextStyle(fontSize: 14),
                                                                  textAlign: TextAlign.end,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: double.maxFinite,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor.withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    ),
                                  ),
                                ):Container()
                              ],
                            )
                        );
                      },
                      fallback: (c)=>Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator(color: primaryColor,)),
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
