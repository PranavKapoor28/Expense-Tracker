import 'package:ecommerce_buisness_tech/Order/EveningOrder/EveningOrdersList.dart';
import 'package:ecommerce_buisness_tech/User/UserEvening.dart';
import 'package:ecommerce_buisness_tech/User/add_evening_user.dart';
import 'package:ecommerce_buisness_tech/database/firebase_database_evening.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class EveningUserDashboard extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<EveningUserDashboard>
    implements AddUserCallback {
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
                'Add Customers',
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
        backgroundColor: Colors.cyan,
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
  void addUser(UserEvening userEvening) {
    setState(() {
      databaseUtil.addUser(userEvening);
    });
  }

  @override
  void update(UserEvening userEvening) {
    setState(() {
      databaseUtil.updateUser(userEvening);
    });
  }

  Widget showUser(DataSnapshot res) {
    UserEvening userEvening = UserEvening.fromSnapshot(res);
    var ref = FirebaseDatabase.instance.reference().child("");
    ref.orderByChild("timestamp").once().then((snap) {
      print(snap.value);
    });
    var item = new Card(
      child: new Container(
          child: new Center(
            child: new Row(
              children: <Widget>[
                new CircleAvatar(
                  radius: 30.0,
                  child: new Text(getShortName(userEvening)),
                  backgroundColor: Colors.blue[100],
                ),
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              userEvening.name,
                              // set some style to text
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                            ),
                            Text(
                              userEvening.mobile,
                              // set some style to text
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black45),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              userEvening.price,
                              // set some style to text
                              style: new TextStyle(
                                  fontSize: 24.0, color: Colors.green),
                            ),
                          ],
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
                      onPressed: () => showEditWidget(userEvening, true),
                    ),
                    new IconButton(
                      icon: const Icon(Icons.delete_forever,
                          color: const Color(0xFF167F67)),
                      onPressed: () => deleteUser(userEvening),
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
                              builder: (context) => EveningOrdersList()),
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

  String getShortName(UserEvening user) {
    String shortName = "";
    if (!user.name.isEmpty) {
      shortName = user.name.substring(0, 1);
    }
    return shortName;
  }

  showEditWidget(UserEvening userEvening, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AddEveningDialog()
          .buildAboutDialog(context, this, isEdit, userEvening),
    );
  }

  deleteUser(UserEvening userEvening) {
    setState(() {
      databaseUtil.deleteUser(userEvening);
    });
  }
}
