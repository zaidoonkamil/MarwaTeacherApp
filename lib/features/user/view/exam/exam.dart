import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/circular_progress.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../ads.dart';
import 'exam_details.dart';
import 'exams_details_bulk.dart';

class Exam extends StatelessWidget {
  const Exam({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getExams(context: context),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           const Text(
                              textAlign: TextAlign.right,
                              'الاختبارات',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 26,),
                        Expanded(
                            child: ConditionalBuilder(
                                condition: state is !GetExamsLoadingState,
                                builder: (c){
                                  return ConditionalBuilder(
                                      condition: cubit.examsModel.isNotEmpty,
                                      builder: (c){
                                        return ListView.builder(
                                            itemCount: cubit.examsModel.length,
                                            itemBuilder: (context,index){
                                              DateTime dateTime = DateTime.parse(cubit.examsModel[index].createdAt.toString());
                                              String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                              return   TweenAnimationBuilder(
                                                duration: Duration(milliseconds: 400 + (index * 100)),
                                                tween: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero),
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
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if(cubit.examsModel[index].questionCounts.text == 0){
                                                          navigateTo(context, ExamDetails(
                                                            questionsId: cubit.examsModel[index].id.toString(),
                                                          ));
                                                        }else{
                                                          navigateTo(context, ExamsDetailsBulk(
                                                            examId: cubit.examsModel[index].id.toString(),
                                                          ));
                                                        }

                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                                        width: double.maxFinite,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: primaryColor,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2,
                                                          )
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  SizedBox(height: 12,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          cubit.examsModel[index].title,
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white
                                                                          ),
                                                                          textAlign: TextAlign.end,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 6,),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        formattedDate,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white70,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(width: 6,),
                                                            Container(
                                                              width: 60,
                                                              height: 60,
                                                              padding: EdgeInsets.all(4),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(12),
                                                                color: Colors.grey.withOpacity(0.5),
                                                              ),
                                                              child: Icon(Icons.newspaper,color: Colors.white,size: 28,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12,),
                                                  ],
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
