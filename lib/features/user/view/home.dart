import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/widgets/background.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:intl/intl.dart';

import 'ads.dart';
import 'lessons/custom_lesson.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  static ScrollController? scrollController;
  static int currentIndex = 0;
  static int currentIndex2 = 0;
  static List<String> tips = [
    '✔️ لا تنسَ مراجعة درس اليوم',
    '🧠 التكرار سرّ الإتقان – راجع القواعد باستمرار',
    '🕒 الامتحان يقترب؟ ابدأ الآن وخفّف الضغط',
    '💬 عندك سؤال؟ الأستاذ بانتظارك في قسم التواصل',
    '📊 طوّر مستواك مع كل اختبار – التقدّم يبدأ بخطوة',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getAds(context: context, page: '1')
        ..getProfile(context: context)
        ..getCourses(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
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
                                SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12,),
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
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
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
                                CarouselSlider(
                                  items: tips.map((tip) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: primaryColor,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tip,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 50,
                                    viewportFraction: 0.9,
                                    enlargeCenterPage: true,
                                    reverse: true,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 5),
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                        currentIndex2 = index;
                                        cubit.slid2();
                                    },
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
                                          navigateTo(context, CustomLessonUser(courseId: cubit.coursesModel[index].id.toString()));
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
                                          child: Column(
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
                                                          width: 80,
                                                          height: 80,
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
                          Center(child: CircularProgress()),
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
