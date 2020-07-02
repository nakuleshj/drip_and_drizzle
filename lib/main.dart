import 'package:dripanddrizzle/constants.dart';
import 'package:dripanddrizzle/screens/login_screen.dart';
//import 'package:dripanddrizzle/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        theme: ThemeData(primaryColor: kPrimaryColor,accentColor: kPrimaryColor),
        debugShowCheckedModeBanner: false,
        home: status == true ?HomeScreenLayout():LoginScreen(),
      ),
    ),
    );
}
class DripAndDrizzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
