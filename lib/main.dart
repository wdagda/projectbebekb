import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  runApp(const SmartDuckFarmApp());
}

class SmartDuckFarmApp extends StatelessWidget {
  const SmartDuckFarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Duck Farm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F5), // LavenderBlush (light pink)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.pages,
    );
  }
}
