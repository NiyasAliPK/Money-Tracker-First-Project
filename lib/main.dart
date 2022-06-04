import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management_app_using_flutter/controller/getx_controller.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';
import 'package:money_management_app_using_flutter/models/transaction_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_splash_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  await GetStorage.init('NotificationTurnedOn');
  await GetStorage.init('ValueOfTimeMinute');
  await GetStorage.init('ValueOfTimeHour');

  ControllerGetX();
  await TransactionDatabase.instance.getAlltransactions();

  await TransactionDatabase.instance.piedata();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ZenDots',
      ),
      home: const ScreenSplashScreen(),
    );
  }
}
