import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:marwa_teacher/core/navigation_bar/navigation_bar.dart';
import 'package:marwa_teacher/core/widgets/background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/navigation_bar/navigation_bar_Admin.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginSuccessState){
            CacheHelper.saveData(
              key: 'token',
              value: LoginCubit.get(context).token,
            ).then((value) {
              CacheHelper.saveData(
                key: 'id',
                value: LoginCubit.get(context).id,
              ).then((value) {
                CacheHelper.saveData(
                  key: 'role',
                  value: LoginCubit.get(context).role,
                ).then((value) {
                  token = LoginCubit.get(context).token.toString();
                  id = LoginCubit.get(context).id.toString();
                  adminOrUser = LoginCubit.get(context).role.toString();
                  if (adminOrUser == 'admin') {
                    navigateAndFinishAnimation(context, BottomNavBarAdmin());
                  } else {
                    navigateAndFinishAnimation(context, BottomNavBar());
                  }
                });
              });
            });
          }
        },
        builder: (context,state){
          var cubit=LoginCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 100,),
                            Lottie.asset(
                              'assets/lottie/Chemistry.json',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 60),
                            CustomTextField(
                              hintText: 'رقم الهاتف',
                              controller: userNameController,
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
                              hintText: 'كلمة السر',
                              prefixIcon: Icons.lock,
                              controller: passwordController,
                              obscureText: cubit.isPasswordHidden,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  cubit.togglePasswordVisibility();
                                },
                                child: Icon(
                                  cubit.isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل الرمز السري';
                                }
                              },
                            ),
                            const SizedBox(height: 60),
                            ConditionalBuilder(
                              condition: state is !LoginLoadingState,
                              builder: (c){
                                return GestureDetector(
                                  onTap: (){
                                    if (formKey.currentState!.validate()) {
                                      cubit.signIn(
                                          phone: userNameController.text.trim(),
                                          password: passwordController.text.trim(),
                                          context: context
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('تسجيل الدخول',
                                          style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              fallback: (c)=> CircularProgressIndicator(color: primaryColor),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap:()async{
                                    final url =
                                        'https://t.me/GaMa19f';
                                    await launch(
                                      url,
                                      enableJavaScript: true,
                                    ).catchError((e) {
                                      showToastError(
                                        text: e.toString(),
                                        context: context,
                                      );
                                    });
                                  },
                                  child: const Text(
                                    'تواصل مع الدعم للتسجيل\n علما ان سعر الاشتراك بالمنصة 10 الاف',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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
