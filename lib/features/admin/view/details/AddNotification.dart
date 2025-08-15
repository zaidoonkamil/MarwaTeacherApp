import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AddNotification extends StatelessWidget {
  const AddNotification({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController tittleController = TextEditingController();
  static TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddNotificationSuccessState){
            tittleController.text='';
            descController.text='';
            showToastSuccess(
              text: "تم الارسال بنجاح",
              context: context,
            );
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
                                        child: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
                                    const Text(
                                      textAlign: TextAlign.right,
                                      'ارسال اشعار',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
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
                                const SizedBox(height: 60),
                                ConditionalBuilder(
                                  condition: state is !AddNotificationLoadingState,
                                  builder: (context){
                                    return GestureDetector(
                                      onTap: (){
                                        if (formKey.currentState!.validate()) {
                                          cubit.addNotification(
                                            tittle: tittleController.text.trim(),
                                            desc: descController.text.trim(),
                                            context: context,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                            borderRadius:  BorderRadius.circular(12),
                                            color: primaryColor
                                        ),
                                        child: Center(
                                          child: Text('ارسال الاشعار',
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
