import 'package:e_commerce_shop/ui/screens/auth_screen/login_screen.dart';
import 'package:e_commerce_shop/ui/screens/home_screen/home_screen.dart';
import 'package:e_commerce_shop/widgets/shared_pref.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SharedPref.getToken()== null ?LoginScreen(): const HomeScreen(),
    );
  }
}

