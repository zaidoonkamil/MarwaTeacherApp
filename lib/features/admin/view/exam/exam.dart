import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:marwa_teacher/features/admin/view/details/dgree_student.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../details/AddQuestion.dart';
import '../details/AddQuestionBulk.dart';
import 'exam_details.dart';
import 'exams_details_bulk.dart';

class ExamAdmin extends StatelessWidget {
  const ExamAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getExams(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
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
                                              return Column(
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
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors.grey.shade300,
                                                          width: 1.5,
                                                        )
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
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
                                                                            ),
                                                                            textAlign: TextAlign.end,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 6,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap:(){
                                                                              cubit.deleteExam(id: cubit.examsModel[index].id.toString(), context: context);
                                                                            },
                                                                            child: Icon(Icons.delete,color: Colors.red,)),
                                                                        Text(
                                                                          formattedDate,
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: primaryColor,
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
                                                          SizedBox(height: 10,),
                                                          cubit.examsModel[index].questionCounts.text == 0 &&
                                                              cubit.examsModel[index].questionCounts.multipleChoice == 0?
                                                          Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: (){
                                                                  navigateTo(context, AddQuestionPage(examId: cubit.examsModel[index].id.toString()));
                                                                },
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.2),
                                                                          blurRadius: 10,
                                                                          spreadRadius: 2,
                                                                          offset: const Offset(5, 5),
                                                                        ),
                                                                      ],
                                                                      borderRadius:  BorderRadius.circular(8),
                                                                      color: primaryColor
                                                                  ),
                                                                  child: Center(
                                                                    child: Text('اضافة سؤال (اختيارات)',
                                                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  navigateTo(context, AddTextQuestionsPage(examId: cubit.examsModel[index].id.toString()));
                                                                },
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.2),
                                                                          blurRadius: 10,
                                                                          spreadRadius: 2,
                                                                          offset: const Offset(5, 5),
                                                                        ),
                                                                      ],
                                                                      borderRadius:  BorderRadius.circular(8),
                                                                      color: primaryColor
                                                                  ),
                                                                  child: Center(
                                                                    child: Text('اضافة سؤال (ورقي)',
                                                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ): GestureDetector(
                                                            onTap: (){
                                                              if(cubit.examsModel[index].questionCounts.text == 0){
                                                                navigateTo(context, DgreeStudent(questionId: cubit.examsModel[index].id.toString(), type: 'multy',));
                                                              }else{
                                                                navigateTo(context, DgreeStudent(questionId: cubit.examsModel[index].id.toString(), type: 'text',));
                                                              }
                                                            },
                                                            child: Container(
                                                              width: double.infinity,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black.withOpacity(0.2),
                                                                      blurRadius: 10,
                                                                      spreadRadius: 2,
                                                                      offset: const Offset(5, 5),
                                                                    ),
                                                                  ],
                                                                  borderRadius:  BorderRadius.circular(8),
                                                                  color: primaryColor
                                                              ),
                                                              child: Center(
                                                                child: Text('درجات الطلاب',
                                                                  style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12,),
                                                ],
                                              );
                                            });
                                      },
                                      fallback: (c)=>Center(child: Text('لا يوجد بيانات ليتم عرضها')));
                                },
                                fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,)))
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
