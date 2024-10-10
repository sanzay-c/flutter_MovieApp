import 'package:flutter/material.dart';
import 'package:movieapp/screens/homescreen.dart';
import 'package:movieapp/screens/more_screen.dart';
import 'package:movieapp/screens/search_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.search),
              text: "Search",
            ),
            Tab(
              icon: Icon(Icons.photo_library_outlined),
              text: "New & Hot",
            )
          ],
          indicatorColor: Colors.white,
          labelColor: Color(0xff999999),
        ),
        body: TabBarView(
          children: [
            Homescreen(),
            SearchScreen(),
            MoreScreen(),
          ],
        ),
      ),
    );
  }
}
