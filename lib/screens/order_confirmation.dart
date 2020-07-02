import 'package:dripanddrizzle/components/pay_with_upi.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
class OrderConfirmation extends StatefulWidget {
  OrderConfirmation({@required this.mobNo,@required this.addr,@required this.name,@required this.email,@required this.deliveryDate});
  final String mobNo;
  final String addr;
  final String name;
  final String email;
  final String deliveryDate;
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}
class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  void initState() {
    super.initState();
    print('Mob No.: ${widget.mobNo}');
    print('Addr: ${widget.addr}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Card(
              elevation: 2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.095,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Your Order',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Lato',
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:10.0),
                          child:Container(
                            height:1.0,
                            width:MediaQuery.of(context).size.width*0.6,
                            color:kPrimaryColor,),),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                for (Map item in cart.items)
                                ListTile(
                                  dense: true,
                                  title: Text('${item['productName']}',
                                      style: TextStyle(fontSize: 18,fontFamily: 'Lato')),
                                  subtitle: Text('x ${item['quantity']}',
                                      style: TextStyle(fontSize: 17,fontFamily: 'Lato')),
                                  trailing: Text(
                                    '$kRupeeSymbol ${item['quantity'] * item['price']}',
                                    style: TextStyle(fontSize: 18,fontFamily: 'Lato'),
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
                              Text('Total: ',style: TextStyle(fontSize: 23,fontFamily: 'Lato'),),
                              Text('$kRupeeSymbol ${cart.total}',style: TextStyle(fontSize: 23,fontFamily: 'Lato'),),
                            ],
                          ),
                        ),),
                        Padding(
                          padding:  EdgeInsets.all(15.0),
                          child: Align(alignment:Alignment.centerLeft,child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text('Pay through UPI:',style: TextStyle(fontSize: 22,fontFamily: 'Lato',color: Colors.black),),
                              PayWithUPI(mobNo: widget.mobNo,addr: widget.addr,email: widget.email,name: widget.name,deliveryDate:widget.deliveryDate),
                            ],
                          ),),
//                          FlatButton(onPressed: (){
//                                int i=0;
//                                Map order=Map<String,dynamic>();
//                                for (Map item in cart.items)
//                                  {
//                                    order['item ${i++}']='${item['productName']} x ${item['quantity']} = ${item['quantity'] * item['price']}';
//                                  }
//                                order['customerName']=widget.name;
//                                order['customerAddress']=widget.addr;
//                                order['customerMobileNumber']=widget.mobNo;
//                                order['customerEmail']=widget.email;
//                                order['TotalPrice']='${cart.total}';
//                                print(order);
//                                cart.clearState();
//                                instance.collection('Orders').add(order);
//                                Navigator.of(context).pushAndRemoveUntil(
//                                  MaterialPageRoute(
//                                    builder: (context) {
//                                      return AppSkeleton();
//                                    },
//                                  ),
//                                    (r)=>false,
//                                );
//                          }, child: Container(
//                            color: kBackgroundColor,
//                            height: MediaQuery.of(context).size.height * 0.08,
//                            child: Center(
//                              child: Text('Place Order',style: TextStyle(fontSize: 30,
//                                  fontFamily: 'Lato',
//                                  color: kPrimaryColor,
//                                  fontWeight: FontWeight.bold),),
//                            ),
//                          ),),
                        ),
                        ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
