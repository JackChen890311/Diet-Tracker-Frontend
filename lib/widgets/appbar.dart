import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const MyAppBar({super.key, required this.title});

  final String title;

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
        actions: [
          const SizedBox(width: 30),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('Account button pressed');
            }
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              print('Image button pressed');
            }
          ),
          const SizedBox(width: 30),
        ]
    );
  }
}