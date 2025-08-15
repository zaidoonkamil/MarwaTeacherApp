import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../core/ navigation/navigation.dart';
import '../../core/navigation_bar/navigation_bar.dart';
import '../../core/navigation_bar/navigation_bar_Admin.dart';
import '../../core/network/local/cache_helper.dart';
import '../../core/widgets/background.dart';
import '../../core/widgets/constant.dart';
import '../auth/view/login.dart';
import '../onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Widget? widget;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      if(CacheHelper.getData(key: 'token') == null){
        token='';
        if (onBoarding == true) {
          widget = const Login();
        } else {
          widget = OnboardingScreen();
        }
      }else{
        if(CacheHelper.getData(key: 'role') == null){
          widget = const Login();
          adminOrUser='user';
        }else{
          adminOrUser = CacheHelper.getData(key: 'role');
          if (adminOrUser == 'admin') {
           widget = BottomNavBarAdmin();
          }else{
            widget = BottomNavBar();
          }
        }
        token = CacheHelper.getData(key: 'token') ;
        id = CacheHelper.getData(key: 'id') ??'' ;
      }

     navigateAndFinishAnimation(context, widget);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            Center(
              child: Lottie.asset(
                'assets/lottie/Chemistry.json',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
