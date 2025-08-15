import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/styles/themes.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import 'details_person.dart';

class AllPerson extends StatelessWidget {
  const AllPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getNameUser(context: context, page: '1' ),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
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
                                child: Icon(Icons.arrow_back_ios_new,)),
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
                        ConditionalBuilder(
                            condition: cubit.getNameUserModel != null,
                            builder: (c){
                              return Expanded(
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: cubit.getNameUserModel!.users.length,
                                    itemBuilder:(context,index){
                                      if (index == cubit.user.length - 1 && !cubit.isLastPage1) {
                                        cubit.getNameUser(page: (cubit.currentPage1 + 1).toString(),context:context);
                                      }
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              navigateTo(context, DetailsPerson(
                                                  id: cubit.getNameUserModel!.users[index].id.toString(),
                                                  name: cubit.getNameUserModel!.users[index].name,
                                                  phone: cubit.getNameUserModel!.users[index].phone,
                                                role: cubit.getNameUserModel!.users[index].role,
                                                  createdAt:  cubit.getNameUserModel!.users[index].createdAt.toString(),
                                              ),
                                              );
                                            },
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
                                                  GestureDetector(
                                                      onTap:(){
                                                        cubit.deleteUser(id: cubit.getNameUserModel!.users[index].id.toString(), context: context);
                                                      },
                                                      child: Icon(Icons.delete,color: Colors.red,)),
                                                  Text(
                                                    cubit.getNameUserModel!.users[index].name,
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
                                    }),
                              );
                            },
                            fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,),),
                        ),
                        SizedBox(height: 80,),
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
