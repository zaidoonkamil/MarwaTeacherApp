import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AddTextQuestionsPage extends StatefulWidget {
  final String examId;
  const AddTextQuestionsPage({super.key, required this.examId});

  @override
  State<AddTextQuestionsPage> createState() => _AddTextQuestionsPageState();
}

class _AddTextQuestionsPageState extends State<AddTextQuestionsPage> {
  TextEditingController questionController = TextEditingController();
  List<TextQuestionData> textQuestions = [];

  void resetField() {
    questionController.clear();
  }

  void addTextQuestion(BuildContext context) {
    final text = questionController.text.trim();

    if (text.isEmpty) {
      showToastError(text: "يرجى إدخال السؤال", context: context);
      return;
    }

    textQuestions.add(TextQuestionData(text: text));
    showToastSuccess(text: "تمت إضافة السؤال", context: context);
    resetField();
    setState(() {});
  }

  void submitAllQuestions(BuildContext context) {
    if (textQuestions.isEmpty) {
      showToastError(text: "أضف سؤالًا واحدًا على الأقل", context: context);
      return;
    }

    AdminCubit.get(context).addTextQuestions(
      examId: widget.examId,
      questions: textQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if (state is AddQuestionSuccessState) {
            showToastSuccess(text: "تم إرسال جميع الأسئلة", context: context);
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is AddQuestionErrorState) {
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
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
                              'الأسئلة النصية',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: questionController,
                          hintText: "اكتب السؤال هنا",
                          prefixIcon: Icons.question_answer,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'رجاءً أدخل السؤال';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => addTextQuestion(context),
                          child: const Text("إضافة السؤال"),
                        ),
                        const SizedBox(height: 10),
                        Text("عدد الأسئلة المضافة: ${textQuestions.length}"),
                        const Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primaryColor),
                          ),
                          onPressed: () => submitAllQuestions(context),
                          child: const Text("إرسال جميع الأسئلة", style: TextStyle(color: Colors.white)),
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

class TextQuestionData {
  final String text;

  TextQuestionData({required this.text});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': 'text',
    };
  }
}
