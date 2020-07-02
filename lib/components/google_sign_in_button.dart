import 'package:flutter/material.dart';
import 'package:dripanddrizzle/constants.dart';

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(color: kPrimaryColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset('images/google_logo.png',height: 25,width: 25,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 18,
                  color: kBackgroundColor,
                  //fontFamily: 'Lato',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}