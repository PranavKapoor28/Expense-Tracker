import 'package:ecommerce_buisness_tech/Category/EveningCategory/EveningAcoount.dart';
import 'package:ecommerce_buisness_tech/Category/EveningCategory/evening_user_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TabBarEvening());
}

class TabBarEvening extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading:IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context,false),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.supervised_user_circle)),
                Tab(icon: Icon(Icons.verified_user)),

              ],
            ),
            title: Text('Customers List'),
          ),
          body: TabBarView(
            children: [
              EveningUserDashboard(),
              EveningAccountDashboard(),
            ],
          ),
        ),
      ),
    );
  }
}