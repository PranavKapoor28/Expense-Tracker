import 'file:///C:/Users/Pranav%20kapoor/AndroidStudioProjects/Internship%20apps/ecommerce_buisness_tech/lib/Category/MorningCategory/MorningCategory.dart';
import 'package:ecommerce_buisness_tech/Category//EveningCategory/eveningCategory.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading:IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,false),
        ),
        title: Text('Add Customers'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 140,
              ),
              new Text(
                "Add your Customers",
                textScaleFactor: 3.0,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(29.0),
              ),
              new Text(
                "Select slot of your " +
                    "\n"
                        "Customers",
                textAlign: TextAlign.center,
                textScaleFactor: 3.0,
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
              SizedBox(height: 80),
              RaisedButton(
                child: Text(
                  'Morning',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => TabBarDemo(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                child: Text(
                  'Evening',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => TabBarEvening(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
