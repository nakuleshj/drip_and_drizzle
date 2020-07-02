import 'package:dripanddrizzle/screens/catalog_screen.dart';
import 'package:dripanddrizzle/screens/provide_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CategoryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: DessertCategoryCardRow(
                clr: Colors.white, txt1: 'Cakes', txt2: 'Tarts'),
          ),
          Expanded(
            child: DessertCategoryCardRow(
                clr: Colors.white, txt1: 'Tea Cakes', txt2: 'Cupcakes & Muffins'),
          ),
          Expanded(
            child: DessertCategoryCardRow(
                clr: Colors.white, txt1: 'Cookies', txt2: 'Custom Orders'),
          ),
        ],
      ),
    );
  }
}

class DessertCategoryCardRow extends StatelessWidget {
  DessertCategoryCardRow({@required this.clr, this.txt1, this.txt2});
  final Color clr;
  final String txt1;
  final String txt2;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: DessertCategoryCard(text: txt1, clr: clr),
        ),
        Expanded(
          child: DessertCategoryCard(text: txt2, clr: clr),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class DessertCategoryCard extends StatelessWidget {
  DessertCategoryCard({
    @required this.text,
    @required this.clr,
  });
  void assignCurrentUser() async {
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
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final String text;
  final Color clr;

  @override
  Widget build(BuildContext context) {
    assignCurrentUser();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => text=='Custom Orders'?ProvideDetails(loggedInUser: loggedInUser,isCustomOrder: true,):CatalogScreen(title: text),
          ),
        );
      },
      child: Card(
        elevation:2,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:AssetImage('images/$text.jpg'),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            )
          ],
        ),
        color: clr,
      ),
    );
  }
}
