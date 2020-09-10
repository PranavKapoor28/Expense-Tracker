import 'package:firebase_database/firebase_database.dart';

  class MorningOrder {
    String _id;
    String _quantity;
    String _price;

    MorningOrder(this._id, this._quantity, this._price);

    MorningOrder.map(dynamic obj) {
      this._id = obj['id'];
      this._quantity = obj['quantity'];
      this._price = obj['price'];
    }

    String get id => _id;
    String get quantity => _quantity;
    String get price => _price;

    MorningOrder.fromSnapshot(DataSnapshot snapshot) {
      _id = snapshot.key;
      _quantity = snapshot.value['quantity'];
      _price = snapshot.value['price'];
    }
  }
