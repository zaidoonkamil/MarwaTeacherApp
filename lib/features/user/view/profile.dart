import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/widgets/background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'how_as.dart';

class ProfileUse extends StatelessWidget {
  const ProfileUse({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final cubit = UserCubit()..getProfile(context: context);
        Future.delayed(Duration(milliseconds: 100), () {
          cubit.startPageAnimation(); // Start animation
        });
        return cubit;
      },
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: cubit.isPageLoaded ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        offset: cubit.isPageLoaded ? Offset(0, 0) : Offset(0, 0.2),
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        child: Column(
                          children: [
                            SizedBox(height: 24,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    textAlign: TextAlign.right,
                                    'حسابي',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14,),
                            ConditionalBuilder(
                                condition: cubit.profileModel != null,
                                builder: (c){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/images/Group 1171275632 (1).png'),
                                            SizedBox(height: 8,),
                                            Text(
                                              cubit.profileModel!.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4,),
                                            Text(
                                              cubit.profileModel!.phone,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 6,),
                                      ],
                                    ),
                                  );
                                },
                                fallback: (c)=>CircularProgressIndicator(color: Colors.white,)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 40,),
                                  GestureDetector(
                                    onTap: (){
                                      navigateTo(context, HowAs());
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black87,),
                                            Row(
                                              children: [
                                                Text(
                                                  'من نحن',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(width: 4,),
                                                Image.asset('assets/images/info-circle.png'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                        SizedBox(height: 14,),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:()async{
                                      final url =
                                          'https://wa.me/+964$phoneWoner?text=';
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
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/images/Group 1171275617 (2).png'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'واتساب',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(width: 4,),
                                                Image.asset('assets/images/ic_round-whatsapp (1).png'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                        SizedBox(height: 14,),
                                      ],
                                    ),
                                  ),
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
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/images/Group 1171275618 (2).png'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'التليجرام',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(width: 4,),
                                                Image.asset('assets/images/meteor-icons_telegram.png'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                        SizedBox(height: 14,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 40,),
                                  GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            title: Text("هل ترغب في تسجيل الخروج ؟",
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center,),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("إلغاء",style: TextStyle(color: Colors.black),),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    signOut(context);
                                                  },
                                                  child: Text("نعم",style: TextStyle(color: Colors.white),),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 46,
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
                                            width: 1.5,
                                          ),
                                          borderRadius:  BorderRadius.circular(12),
                                          color: primaryColor
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('تسجيل الخروج',
                                            style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            title: Text("هل ترغب في حذف الحساب ؟",
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center,),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("إلغاء",style: TextStyle(color: Colors.black),),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showToastInfo(
                                                        text: 'تم ارسال طلبك وسوف يتم الرد عليك قريبا',
                                                        context: context);
                                                  },
                                                  child: Text("نعم",style: TextStyle(color: Colors.white),),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 46,
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
                                            width: 1.5,
                                          ),
                                          borderRadius:  BorderRadius.circular(12),
                                          color: primaryColor
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('حذف الحساب',
                                            style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
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
