import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/features/auth/cubit/states.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/show_toast.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void validation(){
    emit(ValidationState());
  }

  bool isPasswordHidden = true;
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(PasswordVisibilityChanged());
  }

  void slid(){
    emit(ValidationState());
  }

  Future<void> registerDevice(String userId) async {
    final playerId = OneSignal.User.pushSubscription.id;

    if (playerId != null) {
      try {
        final response = await DioHelper.postData(
          url: "/register-device",
          data: {
            "user_id": userId,
            "player_id": playerId,
          },
        );

        if (response.statusCode == 200) {
          print("✅ تم تسجيل الجهاز بنجاح");
        } else {
          print("❌ خطأ أثناء تسجيل الجهاز: ${response.statusMessage}");
        }
      } catch (error) {
        print("❌ Error: $error");
      }
    } else {
      print("❌ لم يتم الحصول على player_id من OneSignal");
    }
  }

  signUp({
    required String name,
    required String phone,
    required String password,
    required String location,
    required String role,
    required BuildContext context,
  }){
    emit(SignUpLoadingState());
    DioHelper.postData(
      url: '/users',
      data:
      {
        'name': name,
        'phone': phone,
        'role': role,
        'location': location,
        'password': password,
      },
    ).then((value) {
      emit(SignUpSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(SignUpErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  String? token;
  String? role;
  String? id;

  signIn({required String phone, required String password,required BuildContext context,}){
    emit(LoginLoadingState());
    DioHelper.postData(
      url: '/login',
      data:
      {
        'phone': phone,
        'password': password,
      },
    ).then((value) {
     token=value.data['token'];
     role=value.data['user']['role'];
     id=value.data['user']['id'].toString();
     registerDevice(id!);
     emit(LoginSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(LoginErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


}