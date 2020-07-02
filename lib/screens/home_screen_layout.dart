import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:dripanddrizzle/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/components/category_cards.dart';
import 'package:dripanddrizzle/screens/cart_screen.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomeScreenLayout extends StatefulWidget {
  @override
  _HomeScreenLayoutState createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  //int _selectedIndex=0;
  //List kNavigationItems=<Widget>[HomeScreenLayout(),Container()];
  final firestore = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    FirebaseAuth _auth=FirebaseAuth.instance;
    _auth.currentUser().then((value) => _fcm.subscribeToTopic(value.email.replaceAll("@","")));
      _fcm.getToken().then((value) => print("FirebaseMessaging token: $value"));
    _fcm.configure(
        onMessage: (Map <String, dynamic> message) async{
          showDialog(context: context,
            builder: (context)=>AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(child: Text('Close'),onPressed:(){Navigator.of(context).pop();},)
              ],
            ),
          );
        }
    );
    super.initState();
    Provider.of<CartModel>(context, listen: false).retrieveState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: kPrimaryColor,
            size: 20,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Marquee(
            child: Text(
              'Drip & Drizzle',
              style: TextStyle(
                  color: Color(0xfff368e0), fontFamily: 'Arizonia', fontSize: 30,fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: kPrimaryColor,
                  size: 28,
                ),
                onPressed: () async{
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn',false);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> LoginScreen(),),(r)=>false);
                },
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: kPrimaryColor,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> CartScreen(),),);
                },
              ),
            ),

          ],
        ),
        body: CategoryCards(),//kNavigationItems[_selectedIndex],
      ),
    );
  }
}
