import 'package:dripanddrizzle/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/components/item_list.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dripanddrizzle/screens/cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  CatalogScreen({@required this.title});
  final String title;
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kPrimaryColor,
          size: 30,
        ),
        elevation: 0,
        backgroundColor:Colors.white,
        title: Marquee(
          child: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xfff368e0), fontFamily: 'Lato', fontSize: 28,fontWeight: FontWeight.bold),
          ),
        ),
        //leading: ,
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
              onPressed: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> CartScreen(),),);
                });
              },
            ),
          ),
        ],
      ),
      body: InventoryItemList(category:widget.title),
    );
  }
}
