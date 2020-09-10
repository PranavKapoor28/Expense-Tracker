import 'package:ecommerce_buisness_tech/Order/MorningOrders/MorningOrdersList.dart';
import 'package:ecommerce_buisness_tech/User/add_user_dialog.dart';
import 'package:ecommerce_buisness_tech/User/user.dart';
import 'package:ecommerce_buisness_tech/database/firebase_database_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


class UserDashboard extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<UserDashboard> implements AddUserCallback {
  bool _anchorToBottom = false;
  FirebaseDatabaseUtil databaseUtil;

  @override
  void initState() {
    super.initState();
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
  }

  @override
  void dispose() {
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTitle(BuildContext context) {
      return new InkWell(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Add Morning Customers',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildActions() {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.group_add,
            color: Colors.white,
          ),
          onPressed: () => showEditWidget(null, false),
        ),
      ];
    }

    return new Scaffold(
      appBar: new AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: new FirebaseAnimatedList(
        key: new ValueKey<bool>(_anchorToBottom),
        query: databaseUtil.getUser(),
        reverse: _anchorToBottom,
        sort: _anchorToBottom
            ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            : null,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return new SizeTransition(
            sizeFactor: animation,
            child: showUser(snapshot),
          );
        },
      ),
    );
  }

  @override
  void addUser(User user) {
    setState(() {
      databaseUtil.addUser(user);
    });
  }

  @override
  void update(User user) {
    setState(() {
      databaseUtil.updateUser(user);
    });
  }

  Widget showUser(DataSnapshot res) {
    User user = User.fromSnapshot(res);

    var item = new Card(
      child: new Container(
          child: new Center(
            child: new Row(
              children: <Widget>[
                new CircleAvatar(
                  radius: 30.0,
                  child: new Text(getShortName(user)),
                  backgroundColor: const Color(0xFF20283e),
                ),
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          user.name,
                          // set some style to text
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.lightBlueAccent),
                        ),
                        new Text(
                          user.email,
                          // set some style to text
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.lightBlueAccent),
                        ),
                        new Text(
                          user.age,
                          // set some style to text
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.green),
                        ),
                        new Text(
                          user.mobile,
                          // set some style to text
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.green),
                        ),

                      ],
                    ),
                  ),
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: const Color(0xFF167F67),
                      ),
                      onPressed: () => showEditWidget(user, true),
                    ),

                    new IconButton(
                      icon: const Icon(Icons.delete_forever,
                          color: const Color(0xFF167F67)),
                      onPressed: () => deleteUser(user),
                    ),
                    new IconButton(
                      icon: const Icon(
                        Icons.attach_money,
                        color: const Color(0xFF167F67),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MorningOrdersList()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
    );

    return item;
  }

  String getShortName(User user) {
    String shortName = "";
    if (!user.name.isEmpty) {
      shortName = user.name.substring(0, 1);
    }
    return shortName;
  }

  showEditWidget(User user, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          new AddUserDialog().buildAboutDialog(context, this, isEdit, user),
    );
  }

  deleteUser(User user) {
    setState(() {
      databaseUtil.deleteUser(user);
    });
  }
}
