import 'package:dripanddrizzle/screens/provide_details.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dripanddrizzle/services/cart_model.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int qty = 1;
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser loggedInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
  }
  void currentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.displayName);
      }
      if(user==null) {

      }
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kPrimaryColor,
          size: 30,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Your Cart',
          style: TextStyle(
              color: kPrimaryColor,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 28,
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.delete,
                color: kPrimaryColor,
                size: 28,
              ),
              onPressed: () async{
                Provider.of<CartModel>(context, listen: false).clearState();
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Consumer<CartModel>(
                builder: (context, cart, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                        itemExtent: 80.0,
                        children: <Widget>[
                          for(Map item in cart.items)
                          Dismissible(
                            key: Key(item['productName']),
                            background: Container(color: Colors.red,child:Icon(Icons.delete,size:30),),
                            onDismissed: (direction){
                              setState(() {
                                cart.deleteItem(item['productName']);
                              });
                            },
                            child: ListTile(
                              title: Text(item['productName'],
                                style: TextStyle(fontFamily: 'Lato', fontSize: 18),
                              ),
                              subtitle: Text('$kRupeeSymbol ${(item['price']*item['quantity']).toString()}',style: TextStyle(fontFamily: 'Lato', fontSize: 17),),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Qty.',
                                    style: TextStyle(fontSize: 18, color: Colors.black54),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          cart.decrementQuantity(item['productName']);
                                          setState(() {
                                            if (item['quantity']<1) {
                                              cart.deleteItem(item['productName']);
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: kPrimaryColor,
                                          size: 25,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          item['quantity'].toString(),
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              cart.incrementQuantity(item['productName']);
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: kPrimaryColor,
                                            size: 25,
                                          ),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                ),
                      ),
                      Align(alignment:Alignment.bottomLeft,child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total: ',style: TextStyle(fontSize: 25,fontFamily: 'Lato'),),
                          Text('$kRupeeSymbol ${cart.total}',style: TextStyle(fontSize: 25,fontFamily: 'Lato'),),
                        ],
                      ),
                      ),),
                    ],
                  );
                  },
              ),
            ),
            GestureDetector(
              onTap: (){

                Provider.of<CartModel>(context, listen: false).isCartEmpty()?_scaffoldKey.currentState.showSnackBar(SnackBar(content: Container(alignment:Alignment.center,height: 50,child: Text("Cart is empty!",style: TextStyle(color: kPrimaryColor,fontSize: 20,fontFamily: 'Lato'),),
                ),duration: Duration(milliseconds: 900),behavior: SnackBarBehavior.floating,backgroundColor: Colors.white,),):Navigator.push(context, MaterialPageRoute(builder: (context)=>ProvideDetails(loggedInUser: loggedInUser,),),);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.5), //(x,y)
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: 'Lato',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: kPrimaryColor,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
