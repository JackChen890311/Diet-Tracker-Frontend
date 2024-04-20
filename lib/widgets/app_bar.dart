import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const MyAppBar({super.key, required this.title, this.canGoBack = false});

  final String title;
  final bool? canGoBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {
        //     print('Menu button pressed');
        //   },
        // ),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          }
        ),
        automaticallyImplyLeading: canGoBack! ? true : false,
        actions: [
          const SizedBox(width: 30),
          IconButton(
            icon: const Icon(Icons.home_filled),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/account');
            }
          ),
          const SizedBox(width: 30),
        ]
    );
  }
}