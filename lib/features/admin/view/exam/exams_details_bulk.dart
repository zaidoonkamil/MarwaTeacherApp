import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/widgets/show_toast.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class ExamsDetailsBulk extends StatelessWidget {
  const ExamsDetailsBulk({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()
        ..getExamsDetailsBulk(context: context, examId: examId),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if(state is AddImageExamSuccessState){
            showToastSuccess(text: 'تم ارسال اجابتك بنجاح', context: context);
            navigateBack(context);
          }

        },
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 14,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  navigateBack(context);
                                },
                                child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),

                            const Text(
                              textAlign: TextAlign.right,
                              'تفاصيل الاختبار',
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
                            condition: state is! GetExamsDetailsLoadingState,
                            builder: (context) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cubit.examsDetailsBulkModel.length,
                                      itemBuilder: (context, index) {
                                        var question = cubit.examsDetailsBulkModel[index];
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF212529),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white,width: 1.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      question.text,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' - ${index + 1}',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  ConditionalBuilder(
                                      condition: state is! GetSubmitExamsLoadingState,
                                      builder:(c){
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                cubit.selectedImages.isNotEmpty?
                                                cubit.addImageExam(context: context, examId: examId):cubit.pickImages();
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                  padding: EdgeInsets.symmetric(vertical: 100),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF212529),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: Colors.white,width: 1.5),
                                                  ),
                                                  child:cubit.selectedImages.isNotEmpty?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('رفع الاجابة',style: TextStyle(fontSize: 22,color: primaryColor,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ):
                                                  Icon(Icons.add_a_photo_outlined,color: Colors.white,)
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                          ],
                                        );
                                      },
                                      fallback: (c)=>CircularProgressIndicator(color: primaryColor,))
                                ],
                              );
                            },
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(color: primaryColor),
                            ),
                          ),
                        ),
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
