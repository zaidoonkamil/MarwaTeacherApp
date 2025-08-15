import 'package:flutter/material.dart';

import '../../features/admin/view/ads/all_ads.dart';
import '../../features/admin/view/details/details.dart';
import '../../features/admin/view/home.dart';
import '../../features/user/view/profile.dart';
import '../styles/themes.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  int currentIndex = 3;
  List<Widget> screens = [
    ProfileUse(),
    Details(),
    AllAdsAdmin(),
    HomeAdmin(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: Offset(0, -3)
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              label: "الحساب",
                icon: currentIndex == 0
                    ? Icon(Icons.person,color: primaryColor,)
                    : Icon(Icons.person,color: Colors.black54,)
            ),
            BottomNavigationBarItem(
              label: "التفاصيل",
              icon: currentIndex == 1
                  ? Icon(Icons.details,color: primaryColor,)
                  : Icon(Icons.details,color: Colors.black54,)
            ),
            BottomNavigationBarItem(
              label: "الاخبار",
              icon: currentIndex == 2
                  ? Icon(Icons.newspaper,color: primaryColor,)
                  : Icon(Icons.newspaper,color: Colors.black54,)
            ),
            BottomNavigationBarItem(
              label: "الرئيسية",
              icon: currentIndex == 3
                  ? Icon(Icons.home,color: primaryColor,)
                  : Icon(Icons.home,color: Colors.black54,)
            ),
          ],
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      )
      ,
    );
  }
}