import 'package:ecommerce_buisness_tech/Category/EveningCategory/EveningAcoount.dart';
import 'package:ecommerce_buisness_tech/Category/EveningCategory/evening_user_dashboard.dart';
import 'package:ecommerce_buisness_tech/Category/categories.dart';
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
            backgroundColor: Colors.cyan[500],
            automaticallyImplyLeading: true,
            leading:IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:() =>  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories()),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.attach_money)),

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