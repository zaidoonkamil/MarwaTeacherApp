import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/navigation_bar/navigation_bar_Admin.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AddLessons extends StatelessWidget {
  const AddLessons({super.key, required this.courseId});

  final String courseId;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController tittleController = TextEditingController();
  static TextEditingController descController = TextEditingController();
  static TextEditingController videoUrlController = TextEditingController();
  static TextEditingController pdfUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddLessonsSuccessState){
            AdminCubit.get(context).selectedImages=[];
            tittleController.text='';
            descController.text='';
            videoUrlController.text='';
            pdfUrlController.text='';
            showToastSuccess(
              text: "تمت العملية بنجاح",
              context: context,
            );
            navigateAndFinish(context, BottomNavBarAdmin());
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body:Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Form(
                            key: formKey,
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
                                      'اضافة محاضرة',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                GestureDetector(
                                    onTap:(){
                                      cubit.pickImages();
                                    },
                                    child:
                                    cubit.selectedImages.isEmpty?
                                    Image.asset('assets/images/Group 1171275632 (1).png'):Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ClipOval(
                                        child: Image.file(
                                          File(cubit.selectedImages[0].path),
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: tittleController,
                                  hintText: 'العنوان',
                                  prefixIcon: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل العنوان';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: descController,
                                  hintText: 'الوصف',
                                  prefixIcon: Icons.description_outlined,
                                  keyboardType: TextInputType.text,
                                  maxLines: 5,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل الوصف';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: videoUrlController,
                                  hintText: 'رابط الفيديو',
                                  prefixIcon: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا رابط الفيديو';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: pdfUrlController,
                                  hintText: 'رابط الملزمة (اختياري)',
                                  prefixIcon: Icons.title,
                                ),
                                const SizedBox(height: 60),
                                ConditionalBuilder(
                                  condition: state is !AddLessonsErrorState,
                                  builder: (context){
                                    return GestureDetector(
                                      onTap: (){
                                        if (formKey.currentState!.validate()) {
                                            cubit.addLessons(
                                              tittle: tittleController.text.trim(),
                                              desc: descController.text.trim(),
                                              videoUrl: videoUrlController.text.trim(),
                                              pdfUrl: pdfUrlController.text.trim(),
                                              courseId: courseId,
                                              context: context,
                                            );
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius:  BorderRadius.circular(12),
                                            color: primaryColor,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            )
                                        ),
                                        child: Center(
                                          child: Text('اضافة',
                                            style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                        ),
                                      ),
                                    );
                                  },
                                  fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                ),
                                const SizedBox(height: 40),
                              ],
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
