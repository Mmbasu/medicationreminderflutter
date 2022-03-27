import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:medi_health1/db/dbHelper.dart';

import 'Screens/getstarted/getstarted.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();


  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: getStarted(),

  ),
  );
}

