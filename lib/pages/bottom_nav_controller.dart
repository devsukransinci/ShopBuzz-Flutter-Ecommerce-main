import 'package:flutter/material.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_pages/cart.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_pages/favorite.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_pages/home.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_pages/profile.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    HomeScreen(),
    CartScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("E-Commerce", style: TextStyle(
            color: Colors.black,),),
            centerTitle: true,
            automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: Color(0xff88C424),
        unselectedItemColor: Color(0xff0A3C73),
        selectedLabelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      body: _pages[_currentIndex],
    );
  }
}
