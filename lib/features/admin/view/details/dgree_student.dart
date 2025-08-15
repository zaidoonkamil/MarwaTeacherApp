import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/network/remote/dio_helper.dart';
import 'package:marwa_teacher/core/styles/themes.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class DgreeStudent extends StatelessWidget {
  const DgreeStudent({super.key, required this.questionId, required this.type});

  final String questionId;
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..answersExam(context: context, questionId: questionId, type: type ),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                  'الطلاب',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (type == 'multy') ConditionalBuilder(
                              condition: cubit.getResultExamModel.isNotEmpty,
                              builder: (c){
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.getResultExamModel.length,
                                    itemBuilder:(context,index){
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap:(){},
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                              height: 45,
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    cubit.getResultExamModel[index].score,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    cubit.getResultExamModel[index].studentName,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${index+1} #',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12,),
                                        ],
                                      );
                                    });
                              },
                              fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,),),
                            ) else ConditionalBuilder(
                              condition: cubit.examAnswersModel.isNotEmpty,
                              builder: (c){
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.examAnswersModel.length,
                                    itemBuilder:(context,index){
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(width: 20,),
                                                    Text(
                                                      cubit.examAnswersModel[index].user.name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${index+1} #',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                cubit.examAnswersModel[index].fileUrl.isNotEmpty?
                                                SizedBox(height: 14,):Container(),
                                                cubit.examAnswersModel[index].fileUrl.isNotEmpty? ListView.builder(
                                                  shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: cubit.examAnswersModel[index].fileUrl.length,
                                                    itemBuilder: (context,i) {
                                                      return Image.network('$url/uploads/${cubit.examAnswersModel[index].fileUrl[i]}',
                                                      fit: BoxFit.fill,);
                                                    },):Container(),
                                                SizedBox(height: 6,),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12,),
                                        ],
                                      );
                                    });
                              },
                              fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,),),
                            ),
                            SizedBox(height: 80,),
                          ],
                        ),
                      )
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
