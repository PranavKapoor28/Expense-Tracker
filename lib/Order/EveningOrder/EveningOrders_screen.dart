import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'EveningOrders.dart';

class EveningOrderScreen extends StatefulWidget {
  final EveningOrder order;
  EveningOrderScreen(this.order);

  @override
  State<StatefulWidget> createState() => new _EveningOrderScreenState();
}

final notesReference =
FirebaseDatabase.instance.reference().child('user').child('Orders');

class _EveningOrderScreenState extends State<EveningOrderScreen> {
  TextEditingController _quantityController;
  TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _quantityController = new TextEditingController(text: widget.order.quantity);
    _priceController = new TextEditingController(text: widget.order.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders'),
    leading: IconButton(icon:Icon(Icons.arrow_back),
    //onPressed:() => Navigator.pop(context, false),
    onPressed:() => exit(0),
    )
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.order.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.order.id != null) {
                  notesReference.child(widget.order.id).set({
                    'quantity': _quantityController.text,
                    'price':_priceController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  notesReference.push().set({
                    'quantity': _quantityController.text,
                    'price': _priceController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
