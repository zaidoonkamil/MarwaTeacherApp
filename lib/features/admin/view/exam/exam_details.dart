import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/widgets/show_toast.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class ExamDetails extends StatefulWidget {
  const ExamDetails({super.key, required this.questionsId});

  final String questionsId;

  @override
  State<ExamDetails> createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {
  Map<int, int> selectedChoices = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()
        ..getExamsDetails(context: context, questionsId: widget.questionsId),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if(state is GetSubmitExamsSuccessState){
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
                    child: ConditionalBuilder(
                      condition: state is! GetExamsDetailsLoadingState,
                      builder: (context) {
                        if (cubit.examsDetailsModel.isEmpty) {
                          return const Center(child: Text('لا يوجد بيانات ليتم عرضها'));
                        }
                        return Column(
                          children: [
                            SizedBox(height: 14,),
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
                              child: ListView.builder(
                                itemCount: cubit.examsDetailsModel.length,
                                itemBuilder: (context, index) {
                                  var question = cubit.examsDetailsModel[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
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
                                        const SizedBox(height: 4),
                                        ...question.choices.map((choice) {
                                          return RadioListTile<int>(
                                            value: choice.id,
                                            groupValue: selectedChoices[question.id],
                                            onChanged: (val) {
                                              setState(() {
                                                selectedChoices[question.id] = val!;
                                              });
                                            },
                                            title: Text(
                                              choice.text,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            activeColor: primaryColor,
                                            controlAffinity: ListTileControlAffinity.trailing,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                          );
                                        }),
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
                              return Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: primaryColor,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('حفظ',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                  ],
                                ),
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
          );
        },
      ),
    );
  }
}
