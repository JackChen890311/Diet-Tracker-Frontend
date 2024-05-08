import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:diet_tracker/pages/home.dart';
import 'package:diet_tracker/pages/account2.dart';
import 'package:diet_tracker/pages/login.dart';
import 'package:diet_tracker/pages/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return pageTransition(settings, const HomePage());
          case '/account':
            return pageTransition(settings, const AccountPage());
          case '/login':
            return pageTransition(settings, const LoginPage());
          case '/chart':
            return pageTransition(settings, const ChartPage());
        }
      }
    );
  }
}

PageTransition pageTransition(RouteSettings settings, Widget child) {
  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: const Duration(milliseconds: 200),
    reverseDuration: const Duration(milliseconds: 200),
  );
}