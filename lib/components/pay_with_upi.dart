import 'package:dripanddrizzle/screens/payment_status_screen.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:upi_india/upi_india.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
Firestore instance=Firestore.instance;
Future<UpiResponse> _transaction;
UpiIndia _upiIndia = UpiIndia();
List<UpiApp> apps;

class PayWithUPI extends StatefulWidget {
  PayWithUPI({@required this.mobNo,@required this.addr,@required this.name,@required this.email,@required this.deliveryDate});
  final String mobNo;
  final String addr;
  final String name;
  final String email;
  final String deliveryDate;
  @override
  _PayWithUPIState createState() => _PayWithUPIState();
}

class _PayWithUPIState extends State<PayWithUPI> {
  @override
  void initState() {
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(String app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: '9167440098@upi',
      receiverName: 'Drip&Drizzle',
      transactionRefId: '',
      transactionNote: 'Pay for delicious Desserts',
      amount: 1,//Provider.of<CartModel>(context, listen: false).total.toDouble(),
    );
  }

  void saveOrder(CartModel cart) {
    int i = 1;
    Map order = Map<String, dynamic>();
    for (Map item in cart.items) {
      order['item ${i++}'] =
          '${item['productName']} x ${item['quantity']} = ${item['quantity'] * item['price']}';
    }
    order['customerName'] = widget.name;
    order['customerAddress'] = widget.addr;
    order['customerMobileNumber'] = widget.mobNo;
    order['customerEmail'] = widget.email;
    order['TotalPrice'] = '${cart.total}';
    order['orderStatus']='Incomplete';
    order['deliveryDate']=widget.deliveryDate;
    print(order);
    cart.clearState();
    instance.collection('Orders').add(order);
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<CartModel>(
                builder: (context, cart, child) {
                  return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: apps.map<Widget>((UpiApp app) {
                    return GestureDetector(
                      onTap: () {
                        _transaction = initiateTransaction(app.app);
                        setState(() {});
                        _transaction.then((value) {
                          if (value.error != null) {
//                            switch (value.error) {
//                              case UpiError.APP_NOT_INSTALLED:
//                                break;
//                              case UpiError.INVALID_PARAMETERS:
//                                break;
//                              case UpiError.NULL_RESPONSE:
//                                break;
//                              case UpiError.USER_CANCELLED:
//                                break;
//                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentStatusScreen(isSuccessful: false),
                                ));
                          }
                          switch (value.status) {
                            case UpiPaymentStatus.SUCCESS:
                            //return StatusScreen(isSuccessful:true);
                              saveOrder(cart);
                              print('Transaction Successful');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentStatusScreen(isSuccessful: true),
                                  ),
                                      (route) => false);
                              break;
                            case UpiPaymentStatus.SUBMITTED:
                              print('Transaction Submitted');
                              break;
                            case UpiPaymentStatus.FAILURE:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentStatusScreen(isSuccessful: false),
                                  ));
                              print('Transaction Failed');
//              return StatusScreen(isSuccessful:false);
                              break;
                            default:
                              print('Received an Unknown transaction status');
                          }
                        });
                      },
                      child:Container(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.memory(
                              app.icon,
                              height: 60,
                              width: 60,
                            ),
                            Text(app.name),
                          ],
                        ),
                      ),
                    );

                  }).toList(),
                );})
              ),
            ),
            Container(
              height: 100,
              color: kBackgroundColor,
              child: Icon(
                Icons.arrow_forward_ios,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        displayUpiApps(),
      ],
    );
  }
}

//class ResponseBuilder extends StatefulWidget {
//  @override
//  _ResponseBuilderState createState() => _ResponseBuilderState();
//}

//class _ResponseBuilderState extends State<ResponseBuilder> {
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: _transaction,
//      builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//        if (snapshot.connectionState == ConnectionState.done) {
//          if (snapshot.hasError) {
//            return Center(
//              child: Text('An Unknown error has occurred'),
//            );
//          }
//          UpiResponse _upiResponse;
//          _upiResponse = snapshot.data;
//          if (_upiResponse.error != null) {
//            String text = '';
//            switch (snapshot.data.error) {
//              case UpiError.APP_NOT_INSTALLED:
//                text = "Requested app not installed on device";
//                break;
//              case UpiError.INVALID_PARAMETERS:
//                text = "Requested app cannot handle the transaction";
//                break;
//              case UpiError.NULL_RESPONSE:
//                text = "requested app didn't returned any response";
//                break;
//              case UpiError.USER_CANCELLED:
//                text = "You cancelled the transaction";
//                break;
//            }
//            return Center(
//              child: Text(text),
//            );
//          }
//          //String txnId = _upiResponse.transactionId;
//          //String resCode = _upiResponse.responseCode;
//          //String txnRef = _upiResponse.transactionRefId;
//          String status = _upiResponse.status;
//          //String approvalRef = _upiResponse.approvalRefNo;
//          switch (status) {
//            case UpiPaymentStatus.SUCCESS:
//              //return StatusScreen(isSuccessful:true);
//              print('Transaction Successful');
//              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>StatusScreen(isSuccessful:true),) ,(route) => false);
//              break;
//            case UpiPaymentStatus.SUBMITTED:
//              print('Transaction Submitted');
//              break;
//            case UpiPaymentStatus.FAILURE:
//              //Navigator.push(context, MaterialPageRoute(builder:(context)=>StatusScreen(isSuccessful:false),));
//              print('Transaction Failed');
////              return StatusScreen(isSuccessful:false);
//              break;
//            default:
//              print('Received an Unknown transaction status');
//          }
//          return Container();
////          return Column(
////            mainAxisAlignment: MainAxisAlignment.center,
////            children: <Widget>[
////              print('Transaction Id: $txnId\n'),
////              Text('Response Code: $resCode\n'),
////              Text('Reference Id: $txnRef\n'),
////              Text('Status: $status\n'),
////              Text('Approval No: $approvalRef'),
////            ],
////          );
//        } else
//          return Text(' ');
//      },
//    );
//  }
//}
