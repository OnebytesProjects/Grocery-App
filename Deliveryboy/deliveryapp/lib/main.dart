// @dart=2.9
import 'package:deliveryapp/HomeScreen/HomeScreen.dart';
import 'package:deliveryapp/Login/Login.dart';
import 'package:deliveryapp/services/UpdateAvaliable.dart';
import 'package:deliveryapp/services/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'SplashScreen/SplashScreen.dart';

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    Provider(create: (_) => AuthProvider()),

  ],
    child:MyApp() ,
  ));

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Login.id: (context) => Login(),
        HomeScreen.id: (context) => HomeScreen(),
        UpdateAvailable.id: (context) => UpdateAvailable(),
      },
      initialRoute: SplashScreen.id,
    );
  }
}
