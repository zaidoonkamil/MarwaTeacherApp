import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:marwa_teacher/features/admin/view/ads/add_ads.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/network/remote/dio_helper.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../user/view/ads.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AllAdsAdmin extends StatelessWidget {
  const AllAdsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getAds(page: '1',context: context),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                           const Text(
                              textAlign: TextAlign.right,
                              'الاخبار',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: (){
                            navigateTo(context, AddAds());
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: primaryColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                )
                            ),
                            child: Text('اضافة اعلان جديد',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 12,),
                        Expanded(
                            child: ConditionalBuilder(
                                condition: state is !GetAdsLoadingState,
                                builder: (c){
                                  return ConditionalBuilder(
                                      condition: cubit.ads.isNotEmpty,
                                      builder: (c){
                                        return ListView.builder(
                                            itemCount: cubit.ads.length,
                                            itemBuilder: (context,index){
                                              DateTime dateTime = DateTime.parse(cubit.ads[index].createdAt.toString());
                                              String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                              if (index == cubit.ads.length - 1 && !cubit.isLastPage) {
                                                cubit.getAds(page: (cubit.currentPage + 1).toString(),context: context);
                                              }
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      navigateTo(context, AdsUser(
                                                        tittle: cubit.ads[index].title,
                                                        desc: cubit.ads[index].description,
                                                        image: cubit.ads[index].images[0],
                                                        time: formattedDate,
                                                      ));
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                                      width: double.maxFinite,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors.grey.shade300,
                                                          width: 1,
                                                        )
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      cubit.ads[index].title,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                      maxLines: 1,
                                                                      textAlign: TextAlign.end,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 4,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        cubit.ads[index].description,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.grey,
                                                                        ),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        textAlign: TextAlign.end,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 6,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: (){
                                                                        cubit.deleteAds(
                                                                            id: cubit.ads[index].id.toString(),
                                                                            context: context);
                                                                      },
                                                                      child: Container(
                                                                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 2),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              color: Colors.red
                                                                          ),
                                                                          child: Icon(Icons.delete,color: Colors.white,)),
                                                                    ),
                                                                    Text(
                                                                      formattedDate,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: primaryColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 6,),
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            child: Image.network(
                                                              "$url/uploads/${cubit.ads[index].images[0]}",
                                                              fit: BoxFit.cover,
                                                              width: 80,
                                                              height: 80,
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
                                      fallback: (c)=>Center(child: Text('لا يوجد بيانات ليتم عرضها')));
                                },
                                fallback: (c)=>Center(child: CircularProgressIndicator(color: primaryColor,)))
                        )
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
