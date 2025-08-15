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

class AddPerson extends StatelessWidget {
  const AddPerson({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is SignUpSuccessState){
            userNameController.text='';
            phoneController.text='';
            passwordController.text='';
            rePasswordController.text='';
            showToastSuccess(
              text: "تم انشاء الحساب بنجاح",
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
                                        child: Icon(Icons.arrow_back_ios_new)),
                                    const Text(
                                      textAlign: TextAlign.right,
                                      'اضافة مستخدم',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 70),
                                CustomTextField(
                                  hintText: 'الاسم الثلاثي',
                                  prefixIcon: Icons.person_outline,
                                  controller: userNameController,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل الاسم الثلاثي';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: phoneController,
                                  hintText: 'رقم الهاتف',
                                  prefixIcon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل رقم الهاتف';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: passwordController,
                                  hintText: 'كلمة السر',
                                  prefixIcon: Icons.lock,
                                  obscureText: false,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل الرمز السري';
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: rePasswordController,
                                  hintText: 'اعد كتابة كلمة السر',
                                  prefixIcon: Icons.lock,
                                  obscureText: false,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اعد ادخال الرمز السري';
                                    }
                                  },
                                ),
                                const SizedBox(height: 60),
                                ConditionalBuilder(
                                  condition: state is !SignUpLoadingState,
                                  builder: (c){
                                    return GestureDetector(
                                      onTap: (){
                                        if (formKey.currentState!.validate()) {
                                          if(passwordController.text == rePasswordController.text){
                                            cubit.signUp(
                                              name: userNameController.text.trim(),
                                              phone: phoneController.text.trim(),
                                              password: passwordController.text.trim(),
                                              role: 'user',
                                              context: context,
                                            );
                                          }else{
                                            showToastError(
                                              text: "كلمة السر غير متطابقة",
                                              context: context,
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                            borderRadius:  BorderRadius.circular(30),
                                            color: primaryColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(width: 50,),
                                            Text('انشاء الحساب',
                                              style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                            Container(
                                              margin: EdgeInsets.all(6),
                                              height: double.maxFinite,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:  BorderRadius.circular(30),
                                                  color: Colors.white
                                              ),
                                              child: Icon(Icons.arrow_forward_ios_outlined,size: 22,color: primaryColor,),
                                            ),
                                          ],
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
