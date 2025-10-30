import 'package:flutter/material.dart';
import 'package:mutual_fund_app/module/scheme/controller/scheme_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutual_fund_app/module/home/view/home_view.dart';
import 'package:mutual_fund_app/module/favourites/controller/favourite_controller.dart';
import 'package:mutual_fund_app/module/nav/controller/nav_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  //initialising controllers
  Get.put(SchemeController());
  Get.put(FavoritesController(),permanent: true);//true keeps alive for enitre cycle
  Get.put(NavController(),permanent:true);
  runApp(const MyApp());
  configLoading();
}
void configLoading(){
  EasyLoading.instance

      ..indicatorType=EasyLoadingIndicatorType.fadingCircle
      ..userInteractions=false
      ..dismissOnTap=false
      ..maskType= EasyLoadingMaskType.black;
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mutual Funds App',
      theme: ThemeData(

        primarySwatch: Colors.indigo
      ),
      builder: EasyLoading.init(),
      home: const HomeScreen(),

    );
  }
}

