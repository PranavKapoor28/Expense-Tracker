import 'package:firebase_database/firebase_database.dart';

class UserEvening {

  String _id;
  String _name;
  String _email;
  String _age;
  String _mobile;
  String _price;

  UserEvening(this._id, this._name, this._email, this._age, this._mobile, this._price);

  String get name => _name;

  String get email => _email;

  String get age => _age;

  String get mobile => _mobile;

  String get id => _id;

  String get price => _price;



  UserEvening.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _email = snapshot.value['email'];
    _age = snapshot.value['age'];
    _mobile = snapshot.value['mobile'];
    _price = snapshot.value['price'];
  }

}
