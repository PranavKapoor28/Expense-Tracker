import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'MorningOrders.dart';
import 'morningOrders_screen.dart';

class MorningOrdersList extends StatefulWidget {
  @override
  _MorningOrdersListState createState() => new _MorningOrdersListState();
}

final notesReference =
FirebaseDatabase.instance.reference().child('user').child('Orders');

class _MorningOrdersListState extends State<MorningOrdersList> {
  List<MorningOrder> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;

  @override
  void initState() {
    super.initState();

    items = new List();

    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription =
        notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Details',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Quantity and Price'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Divider(height: 5.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: <Widget>[
                          Text(
                            '${items[position].quantity}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 50,),
                          Text(
                            '${items[position].price}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ]),
                      ),
                      SizedBox(width: 100,),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: <Widget>[
                            new IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: const Color(0xFF167F67),
                              ),
                              onPressed: () => _navigateToNote(context, items[position]),
                            ),
                            CircleAvatar(
                              maxRadius: 20.0,
                              backgroundColor: Colors.redAccent,
                              child: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _deleteNote(
                                      context, items[position], position)),
                            ),
                          ],

                        ),
                      ),
                    ],

                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewNote(context),
        ),
      ),
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(new MorningOrder.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue =
        items.singleWhere((order) => order.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] =
          new MorningOrder.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(BuildContext context, MorningOrder order, int position) async {
    await notesReference.child(order.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, MorningOrder order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MorningOrderScreen(order)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MorningOrderScreen(MorningOrder(null, '', ''))),
    );
  }
}
