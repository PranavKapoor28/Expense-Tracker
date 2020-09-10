import 'package:firebase_database/firebase_database.dart';

class User {

  String _id;
  String _name;
  String _email;
  String _age;
  String _mobile;


  User(this._id,this._name, this._email, this._age, this._mobile);

  String get name => _name;

  String get email => _email;

  String get age => _age;

  String get mobile => _mobile;

  String get id => _id;



  User.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _email = snapshot.value['email'];
    _age = snapshot.value['age'];
    _mobile = snapshot.value['mobile'];
  }

}

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

