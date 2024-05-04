import 'package:flutter/material.dart';
import 'package:diet_tracker/utils/style.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const MyAppBar({super.key, required this.title, this.canGoBack = false});

  final String title;
  final bool? canGoBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const CustomText(
          label: 'Diet Tracker', color: CustomColor.darkBlue,
          type: 'displayMedium', align: 'left'),
        backgroundColor: CustomColor.white,
        centerTitle: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {
        //     print('Menu button pressed');
        //   },
        // ),
        // leading: IconButton(
        //   icon: const Icon(Icons.logout),
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/login');
        //   }
        // ),
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
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/chart');
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            }
          ),
          const SizedBox(width: 30),
        ]
    );
  }
}