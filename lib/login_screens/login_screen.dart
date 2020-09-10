import 'file:///C:/Users/Pranav%20kapoor/AndroidStudioProjects/Internship%20apps/ecommerce_buisness_tech/lib/Category/categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Using your email'),
        backgroundColor: Colors.black,
      ),
        body: SingleChildScrollView(
        child:CustomPaint(
        painter: BackgroundSignIn(),
      child:Center(
          child: Column(
            children: [
              SizedBox(height: 200,),
              new Text(
                "Login now.",
                textScaleFactor: 3.0,
                style: TextStyle(color: Colors.blue, fontWeight:FontWeight.bold,fontSize: 20),
              ),
              SizedBox(height:130),
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formStateKey,
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validateEmail,
                                onSaved: (value) {
                                  _emailId = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailIdController,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  labelText: "Email Id",
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validatePassword,
                                onSaved: (value) {
                                  _password = value;
                                },
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.blue,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  labelText: "Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (errorMessage != ''
                          ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                          : Container()),

                            SizedBox(height: 50),
                            FlatButton(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.blueAccent,
                              onPressed: () {
                                if (_formStateKey.currentState.validate()) {
                                  _formStateKey.currentState.save();
                                  signIn(_emailId, _password).then((user) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Categories()),
                                    );
                                    if (user != null) {
                                      print('Logged in successfully.');
                                      setState(() {
                                        successMessage =
                                        'Logged in successfully.\nYou can now navigate to Home Page.';

                                      });
                                    } else {
                                      print('Error while Login.');
                                    }
                                  });
                                }
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Sign Up',
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
                                    builder: (context) => RegistrationPage(),
                                  ),
                                );
                              },
                            ),
                          ],

                  ),
                ),
              ),

            ],

          )),
    ),
        ),
    );
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result= await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;


      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }



  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}



class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);


    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.blue;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}