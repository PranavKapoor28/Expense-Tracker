import 'package:firebase_database/firebase_database.dart';

class EveningOrder {
  String _id;
  String _quantity;
  String _price;

  EveningOrder(this._id, this._quantity, this._price);

  EveningOrder.map(dynamic obj) {
    this._id = obj['id'];
    this._quantity = obj['quantity'];
    this._price = obj['price'];
  }

  String get id => _id;
  String get quantity => _quantity;
  String get price => _price;

  EveningOrder.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _quantity = snapshot.value['quantity'];
    _price = snapshot.value['price'];
  }
}
