import 'package:e_commerce_shop/presentation/screens/auth_screen/login_screen.dart';
import 'package:e_commerce_shop/presentation/screens/home_screen/home_screen.dart';
import 'package:e_commerce_shop/presentation/screens/home_screen/tabs/cubit/layout_cubit.dart';
import 'package:e_commerce_shop/widgets/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..getBannersData()..getCategoriesData()..getProducts()..getCarts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SharedPref.getToken()== null ?LoginScreen(): const HomeScreen(),
      ),
    );
  }
}

