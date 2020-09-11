import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'EveningOrders.dart';
import 'EveningOrders_screen.dart';

class EveningOrdersList extends StatefulWidget {
  @override
  _EveningOrdersListState createState() => new _EveningOrdersListState();
}

final notesReference = FirebaseDatabase.instance.reference().child('user').child('Orders');

class _EveningOrdersListState extends State<EveningOrdersList> {
  List<EveningOrder> items;
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
          automaticallyImplyLeading: true,
          leading:IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context,false),
          ),
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
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            '${items[position].price}',
                            style: TextStyle(fontSize: 14.0),
                          )
                        ]),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: <Widget>[
                            new IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: const Color(0xFF167F67),
                              ),
                              onPressed: () =>
                                  _navigateToNote(context, items[position]),
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
      items.add(new EveningOrder.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue =
        items.singleWhere((order) => order.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] =
          new EveningOrder.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(
      BuildContext context, EveningOrder order, int position) async {
    await notesReference.child(order.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, EveningOrder order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EveningOrderScreen(order)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EveningOrderScreen(EveningOrder(null, '', ''))),
    );
  }
}
