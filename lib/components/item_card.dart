import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dripanddrizzle/services/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/constants.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:marquee_widget/marquee_widget.dart';

class ItemCard extends StatefulWidget {
  ItemCard(
      {@required this.title,
      @required this.desc,
      @required this.price,
      @required this.imgID});

  final String title;
  final String desc;
  final String price;
  final String imgID;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  IconData currentCartIcon = Icons.add_shopping_cart;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(fit:StackFit.expand,children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  strokeWidth: 6,
                ),
              ),
              FittedBox(
                fit: BoxFit.fill,
                child: Image(
                  image: FirebaseImage(
                      'gs://dripanddrizzle-327f9.appspot.com/${widget.imgID}',
                      shouldCache: true),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
            ]),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Marquee(
                          child: Text(
                            '${widget.title}',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${widget.desc}',
                          //overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey[700],
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '$kRupeeSymbol${widget.price}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false)
                                  .add(widget.title, widget.price);
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added to cart!',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        color: kPrimaryColor),
                                  ),
                                  backgroundColor: kBackgroundColor,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: Icon(
                              currentCartIcon,
                              color: kPrimaryColor,
                              size: 25,
                            ),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
