import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ridobike/Controller/databaseController.dart';
import 'package:ridobike/Controller/global_controller.dart';
import 'package:ridobike/Screens/splash_screen.dart';
import 'package:ridobike/Utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController());
    Get.put(DataBaseController());
    return MaterialApp(
      title: 'ValueVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
