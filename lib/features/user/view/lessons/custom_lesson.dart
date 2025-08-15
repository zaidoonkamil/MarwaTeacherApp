import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/network/remote/dio_helper.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/circular_progress.dart';
import '../../../user/view/lessons/lessons.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';


class CustomLessonUser extends StatelessWidget {
  const CustomLessonUser({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getLessons(context: context, courseId: courseId,),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  navigateBack(context);
                                },
                                child: Icon(Icons.arrow_back_ios_new)),
                            const Text(
                              textAlign: TextAlign.right,
                              'المحاضرات',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 12),
                        // GestureDetector(
                        //   onTap: (){
                        //     navigateTo(context, AddLessons(courseId: courseId));
                        //   },
                        //   child: Container(
                        //     width: double.maxFinite,
                        //     padding: EdgeInsets.symmetric(vertical: 12),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(8),
                        //         color: primaryColor,
                        //         border: Border.all(
                        //           color: Colors.white,
                        //           width: 1.5,
                        //         )
                        //     ),
                        //     child: Text('اضافة محاضرة جديد',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                        //   ),
                        // ),

                        SizedBox(height: 26,),
                        Expanded(
                            child: ConditionalBuilder(
                                condition: state is !GetLessonsLoadingState,
                                builder: (c){
                                  return ConditionalBuilder(
                                      condition: cubit.getLessonsModel.isNotEmpty,
                                      builder: (c){
                                        return ListView.builder(
                                            itemCount: cubit.getLessonsModel.length,
                                            itemBuilder: (context,index){
                                              DateTime dateTime = DateTime.parse(cubit.getLessonsModel[index].createdAt.toString());
                                              return TweenAnimationBuilder(
                                                duration: Duration(milliseconds: 500 + (index * 50)),
                                                tween: Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero),
                                                curve: Curves.easeOut,
                                                builder: (context, Offset offset, child) {
                                                  return Transform.translate(
                                                    offset: offset * 100,
                                                    child: AnimatedOpacity(
                                                      duration: Duration(milliseconds: 300),
                                                      opacity: 1,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: GestureDetector(
                                                    onTap: () {
                                                      navigateTo(context,
                                                        Lessons(
                                                          videoUrl: cubit.getLessonsModel[index].videoUrl,
                                                          title: cubit.getLessonsModel[index].title,
                                                          description: cubit.getLessonsModel[index].description,
                                                          pdfUrl: cubit.getLessonsModel[index].pdfUrl,
                                                          images: '$url/uploads/${cubit.getLessonsModel[index].images[0]}',
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(16),
                                                      margin: EdgeInsets.symmetric(vertical: 8,),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor.withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      cubit.getLessonsModel[index].title,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        cubit.getLessonsModel[index].description,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.grey,
                                                                        ),
                                                                        textAlign: TextAlign.end,
                                                                        maxLines: 3,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 16),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: primaryColor,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.arrow_left,
                                                              color: Colors.white,
                                                              size: 48,
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              );
                                            });
                                      },
                                      fallback: (c)=>Center(child: Text('لا يوجد بيانات ليتم عرضها')));
                                },
                                fallback: (c)=>Center(child: CircularProgress()))
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
