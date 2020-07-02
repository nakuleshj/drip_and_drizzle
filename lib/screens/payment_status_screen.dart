import 'package:dripanddrizzle/constants.dart';
import 'package:dripanddrizzle/screens/home_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
class PaymentStatusScreen extends StatelessWidget {
  PaymentStatusScreen({@required this.isSuccessful,this.mobNo,this.addr, this.name, this.email});
  final bool isSuccessful;
  final String mobNo;
  final String addr;
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      isSuccessful?Icons.check_circle:Icons.clear,
                      size: 200,
                      color: isSuccessful?Colors.green:Colors.red,
                    ),
                    Text(
                      isSuccessful?'Thank you for choosing us':'Payment failed',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Lato',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    FlatButton(
                      onPressed: () {
                        isSuccessful?Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                          builder: (context) {
                            return HomeScreenLayout();
                          },
                        ), (route) => false):Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(isSuccessful?'Continue Shopping':'Retry Payment',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lato',
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      color: isSuccessful?Colors.green:Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),),),
                    if(!isSuccessful)
                    FlatButton(
                      onPressed: () {
                        Provider.of<CartModel>(context, listen: false).clearState();
                        Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                          builder: (context) {
                            return HomeScreenLayout();//OrderConfirmation(mobNo: null, addr: null, name: null, email: null);
                          },
                        ), (route) => false);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text('Return to Shop',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lato',
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
