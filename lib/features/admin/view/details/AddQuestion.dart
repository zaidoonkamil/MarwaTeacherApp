import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AddQuestionPage extends StatefulWidget {
  final String examId;
  const AddQuestionPage({super.key, required this.examId});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController titleController = TextEditingController();
  List<TextEditingController> choicesControllers = List.generate(4, (_) => TextEditingController());
  int correctChoiceIndex = 0;

  List<QuestionData> questions = [];

  void resetFields() {
    titleController.clear();
    for (var controller in choicesControllers) {
      controller.clear();
    }
    correctChoiceIndex = 0;
  }

  void addQuestionToList(BuildContext context) {
    final title = titleController.text.trim();
    final choices = choicesControllers.map((c) => c.text.trim()).toList();

    if (title.isEmpty) {
      showToastError(text: "يرجى إدخال عنوان السؤال", context: context);
      return;
    }
    if (choices.any((c) => c.isEmpty)) {
      showToastError(text: "كل الخيارات مطلوبة", context: context);
      return;
    }

    questions.add(
      QuestionData(
        text: title,
        choices: choices,
        correctIndex: correctChoiceIndex,
      ),
    );

    showToastSuccess(text: "تمت إضافة السؤال", context: context);
    resetFields();
    setState(() {});
  }

  void submitAllQuestions(BuildContext context) {
    if (questions.isEmpty) {
      showToastError(text: "أضف سؤالًا واحدًا على الأقل", context: context);
      return;
    }

    AdminCubit.get(context).addMultipleQuestions(
      examId: widget.examId,
      questions: questions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if (state is AddQuestionSuccessState) {
            showToastSuccess(text: "تم إرسال جميع الأسئلة", context: context);
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is AddQuestionErrorState) {
            print( state.error);
            showToastError(text: state.error, context: context);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
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
                              'الاسئلة',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Expanded(
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("عنوان السؤال", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller:  titleController,
                                hintText: "",
                                prefixIcon: Icons.title,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'رجائا اخل العنوان';
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("الخيارات", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 12,),
                              ...List.generate(4, (index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          fillColor: MaterialStateProperty.all(primaryColor),
                                          value: index,
                                          groupValue: correctChoiceIndex,
                                          onChanged: (val) {
                                            setState(() {
                                              correctChoiceIndex = val!;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: CustomTextField(
                                            controller: choicesControllers[index],
                                            hintText: "الخيار ${index + 1}",
                                            prefixIcon: Icons.title,
                                            validate: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'رجائا اخل العنوان';
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                  ],
                                );
                              }),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => addQuestionToList(context),
                                child: Text("إضافة السؤال إلى القائمة",style: TextStyle(color: Colors.black),),
                              ),
                              const SizedBox(height: 10),
                              Text("الأسئلة المضافة: ${questions.length}", textAlign: TextAlign.right),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:  MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () => submitAllQuestions(context),
                                child: Text("إرسال جميع الأسئلة",style: TextStyle(color: Colors.black),),
                              ),
                            ],
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


class QuestionData {
  final String text;
  final List<String> choices;
  final int correctIndex;

  QuestionData({
    required this.text,
    required this.choices,
    required this.correctIndex,

  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'choices': List.generate(choices.length, (index) {
        return {
          'text': choices[index],
          'isCorrect': index == correctIndex,
        };
      }),
    };
  }

}
