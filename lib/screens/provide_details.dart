import 'package:dripanddrizzle/constants.dart';
import 'package:dripanddrizzle/screens/home_screen_layout.dart';
import 'package:dripanddrizzle/screens/order_confirmation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
Firestore instance = Firestore.instance;

class ProvideDetails extends StatefulWidget {
  ProvideDetails({@required this.loggedInUser, this.isCustomOrder = false});
  final FirebaseUser loggedInUser;
  final bool isCustomOrder;
  @override
  _ProvideDetailsState createState() => _ProvideDetailsState();
}

class _ProvideDetailsState extends State<ProvideDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kPrimaryColor,
          size: 30,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Place Order',
          style: TextStyle(
              color: Color(0xfff368e0),
              fontFamily: 'Lato',
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              height: widget.isCustomOrder
                  ? MediaQuery.of(context).size.height * 0.95
                  : MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: GetEssentialDetails(
                    loggedInUser: widget.loggedInUser,
                    isCustomOrder: widget.isCustomOrder,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class GetEssentialDetails extends StatefulWidget {
  GetEssentialDetails({this.loggedInUser, @required this.isCustomOrder});
  final FirebaseUser loggedInUser;
  final bool isCustomOrder;
  @override
  GetEssentialDetailsState createState() {
    return GetEssentialDetailsState();
  }
}

// ignore: camel_case_types
class GetEssentialDetailsState extends State<GetEssentialDetails> {
  var format=DateFormat('MMM dd, yyyy');
  var selectedDate =DateTime.now().add(Duration(days: 1));
  var formattedText;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: selectedDate.add(Duration(days: 30)),
        builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData(
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
            //primarySwatch: kPrimaryColor,//OK/Cancel button text color
            primaryColor: kPrimaryColor,//Head background
            accentColor: kPrimaryColor//selection color
          //dialogBackgroundColor: Colors.white,//Background color
        ),
        child: child,
      );
    },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  final _formKey = GlobalKey<FormState>();
  final List<DropdownMenuItem> dropdownList = [
    DropdownMenuItem(
      child: Center(
          child: Text(
        'Wedding Cake',
        style: TextStyle(fontFamily: 'Lato'),
      )),
      value: 'Wedding Cake',
    ),
    DropdownMenuItem(
        child: Center(
            child: Text(
          'Custom Cake',
          style: TextStyle(fontFamily: 'Lato'),
        )),
        value: 'Custom Cake'),
    DropdownMenuItem(
        child: Center(
            child: Text(
          'Hampers',
          style: TextStyle(fontFamily: 'Lato'),
        )),
        value: 'Hampers'),
    DropdownMenuItem(
        child: Center(
            child: Text(
          'Special Orders',
          style: TextStyle(fontFamily: 'Lato'),
        )),
        value: 'Special Order'),
  ];
  String _selectedItem = 'Wedding Cake';
  String addr;
  String mobNo;
  String description;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi ${widget.loggedInUser.displayName.split(" ")[0]},',
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Lato'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Text(
                'Please provide the following details:',
                style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value.isEmpty && value.length < 10) {
                      return 'Please enter a valid Mobile Number';
                    } else
                      return null;
                  },
                  onChanged: (value) {
                    mobNo = value;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: kPrimaryColor,
                    )),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    focusColor: kPrimaryColor,
                    labelText: 'Mobile Number (+91)',
                    labelStyle: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10),
                    WhitelistingTextInputFormatter.digitsOnly,
                    BlacklistingTextInputFormatter.singleLineFormatter,
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value.isEmpty && value.length < 20) {
                        return 'Please enter a valid Address';
                      } else
                        return null;
                    },
                    onChanged: (value) {
                      addr = value;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: kPrimaryColor,
                      )),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      focusColor: kPrimaryColor,
                      labelText: 'Address',
                      labelStyle: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: kPrimaryColor,
                      accentColor: kPrimaryColor
                    ),
                    child: Builder(
                      builder:(context)=> RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color:Colors.white,
                        onPressed: () => _selectDate(context),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Select delivery date' ,style:TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
    fontSize: 18)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 18.0,),
                  Text("${format.format(selectedDate)}",style: TextStyle(fontFamily: 'Lato',fontSize: 18),),
                ],
              ),
              widget.isCustomOrder
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                              cursorColor: kPrimaryColor,
                              validator: (value) {
                                if (value.isEmpty && value.length < 20) {
                                  return 'Please enter a valid Description';
                                } else
                                  return null;
                              },
                              onChanged: (value) {
                                description = value;
                              },
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: kPrimaryColor,
                                )),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                focusColor: kPrimaryColor,
                                labelText: 'Brief Description',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      items: dropdownList,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 20),
                                      iconSize: 30,
                                      hint: Text('Select Category'),
                                      value: _selectedItem,
                                      underline: Container(
                                        padding: EdgeInsets.all(2),
                                        height: 2,
                                        color: kPrimaryColor,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItem = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      if (widget.isCustomOrder) {
                        Map customOrder = Map<String, dynamic>();
                        customOrder['customerName'] =
                            widget.loggedInUser.displayName;
                        customOrder['customerAddress'] = addr;
                        customOrder['customerMobileNumber'] = mobNo;
                        customOrder['category'] = _selectedItem;
                        customOrder['customerEmail'] =
                            widget.loggedInUser.email;
                        customOrder['orderStatus']='Incomplete';
                        customOrder['customDescription']=description;
                        customOrder['deliveryDate']=format.format(selectedDate);
                        instance.collection('CustomOrders').add(customOrder);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScreenLayout();
                            },
                          ),
                              (r) => false,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmation(
                                mobNo: mobNo,
                                addr: addr,
                                name: widget.loggedInUser.displayName,
                                email: widget.loggedInUser.email,
                            deliveryDate:format.format(selectedDate)),
                          ),
                        );
                      }
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 1,
                    color: Colors.white,

                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 25),
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
