import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/features/admin/view/details/AddNotification.dart';
import 'package:marwa_teacher/features/admin/view/details/add_person.dart';
import 'package:marwa_teacher/features/admin/view/details/all_person.dart';
import 'package:marwa_teacher/features/admin/view/details/dgree.dart';
import 'package:marwa_teacher/features/admin/view/exam/exam.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import 'AddMainQuestion.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit(),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
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
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    textAlign: TextAlign.right,
                                    'التفاصيل',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 20),
                              // GestureDetector(
                              //   onTap: (){
                              //     navigateTo(context, AddNotification());
                              //   },
                              //   child: Container(
                              //     width: double.infinity,
                              //     height: 48,
                              //     decoration: BoxDecoration(
                              //         borderRadius:  BorderRadius.circular(12),
                              //         color: primaryColor,
                              //         border: Border.all(
                              //           color: Colors.white,
                              //           width: 1.5,
                              //         )
                              //     ),
                              //     child: Center(
                              //       child: Text('اضافة اشعار',
                              //         style: TextStyle(color: Colors.white,fontSize: 16 ),),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, AllPerson());
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
                                    child: Text('الطلاب',
                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, AddQuestion());
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
                                    child: Text('اضافة اختبار',
                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, ExamAdmin());
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
                                    child: Text('الاختبارات ودرجات الطلاب',
                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, Degree());
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
                                    child: Text('اضافة درجات الطلاب',
                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, AddPerson());
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
                                    child: Text('اضافة مستخدم',
                                      style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
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
