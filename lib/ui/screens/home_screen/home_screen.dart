import 'package:e_commerce_shop/ui/screens/home_screen/tabs/cart_tab/cart_tab.dart';
import 'package:e_commerce_shop/ui/screens/home_screen/tabs/category_tab/category_tab.dart';
import 'package:e_commerce_shop/ui/screens/home_screen/tabs/fav_tab/fav_tab.dart';
import 'package:e_commerce_shop/ui/screens/home_screen/tabs/home_tab/home_tab.dart';
import 'package:e_commerce_shop/ui/screens/home_screen/tabs/profile_tab/profile_tab.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int currentIndex =0;
   final List<Widget>tabs = [
     const HomeTab(),
     const CategoryTab(),
     const FavTab(),
     const CartTab(),
     const ProfileTab(),
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: thirdColor,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.menu, size: 33,),
        title: const Text("Welcome", style: TextStyle(fontSize: 26,fontWeight: FontWeight.w600),),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            height: MediaQuery.of(context).size.height * 0.066,
            width: MediaQuery.of(context).size.width * 0.14,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black, size: 32),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index)
        {
          setState(() {
            currentIndex= index;
          });
        },
        items:
        const
        [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category),label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
      body: tabs[currentIndex],
    );
  }
}
