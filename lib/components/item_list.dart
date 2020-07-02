//import 'package:dripanddrizzle/constants.dart';
import 'package:flutter/material.dart';
import 'package:dripanddrizzle/components/item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = Firestore.instance;

class InventoryItemList extends StatefulWidget {
  InventoryItemList({@required this.category});
  final String category;

  @override
  _InventoryItemListState createState() => _InventoryItemListState();
}

class _InventoryItemListState extends State<InventoryItemList> {
  String title;
  String desc;
  int price;
  String imgID;
  var docs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ItemStream(
      category: widget.category,
    );
  }
}

class ItemStream extends StatelessWidget {
  ItemStream({this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(category.replaceAll(' ', '')).snapshots(),
      builder: (context, snapshot) {
        /*if (!snapshot.hasData) {
          return null;
        }*/
        final items = snapshot.data.documents;
        List<ItemCard> itemWidgets = [];
        for (var item in items) {
          itemWidgets.add(
            ItemCard(
                title: item.data['title'],
                desc: item.data['description'],
                price: item.data['price'],
                imgID: item.data['imgID']
                ),
          );
        }
        return ListView(
          itemExtent: 165.0,
          children: itemWidgets,
        );
      },
    );
  }
}
