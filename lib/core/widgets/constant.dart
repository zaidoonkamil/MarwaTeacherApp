import '../ navigation/navigation.dart';
import '../../features/auth/view/login.dart';
import '../network/local/cache_helper.dart';

String token='';
String className='';
String id='';
String adminOrUser='' ;
String phoneWoner='7802709565' ;
String logo='Logo.png' ;

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value)
  {
    token='';
    adminOrUser='' ;
    id='' ;
    if (value)
    {
      CacheHelper.removeData(key: 'role',);
      CacheHelper.removeData(key: 'id',);
     navigateTo(context, const Login(),);
    }
  });
}
