
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/RegisterPage.dart';
import 'package:carpooling_app/AvailableRidesPage.dart';
import 'package:carpooling_app/AddRidePage.dart';
import 'package:carpooling_app/LoginPage.dart';
import 'package:carpooling_app/DriverRidesPage.dart';
import 'package:carpooling_app/DriverRegisterPage.dart';
import 'DatabaseHelper.dart';


bool rememberEmailFlag = false;
bool testingFlag = false;
final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
var rememberedUserProfile;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Database sqldb = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> result = await sqldb.query('user_profiles');

  if (result.isNotEmpty) {
    rememberedUserProfile = result.last;
    print('User Profile: $rememberedUserProfile');
  } else {
    print('User profile not found');
  }

  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      useMaterial3: true
    ),
    title:"Carpooling App",
    initialRoute: '/Login',
    routes: {
      '/Register': (context) => RegisterPage(),
      '/Login': (context) => LoginPage(),
      '/AvailableRides': (context) => AvailableRidesPage(),
      '/AddRide': (context) => AddRidePage(),
      '/DriverRegister': (context) => DriverRegisterPage(),
      '/DriverRides': (context) => DriverRidesPage()
    },
    debugShowCheckedModeBanner: false,
  ));
}
