import 'file:///C:/Users/Pranav%20kapoor/AndroidStudioProjects/Internship%20apps/ecommerce_buisness_tech/lib/Category/MorningCategory/morning_user_dashboard.dart';
import 'package:ecommerce_buisness_tech/Category/MorningCategory/MorningAccount.dart';
import 'package:ecommerce_buisness_tech/Category/categories.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories()),
              ),
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
              UserDashboard(),
              MorningAccountDashboard(),
            ],
          ),
        ),
      ),
    );
  }
}
