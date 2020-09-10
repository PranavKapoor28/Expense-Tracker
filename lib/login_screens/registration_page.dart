import 'package:ecommerce_buisness_tech/login_screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Email Registration'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: BackgroundSignIn(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                new Text(
                  "Register now.",
                  textScaleFactor: 3.0,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(height: 130),
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Form(
                          key: _formStateKey,
                          autovalidate: true,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
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
                                    // hintText: "Company Name",
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
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
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
                                    // hintText: "Company Name",
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: TextFormField(
                                  validator: validateConfirmPassword,
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.blue,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                    // hintText: "Company Name",
                                    labelText: "Confirm Password",
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
                                style: TextStyle(color: Colors.blueAccent),
                              )
                            : Container()),
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
                            if (_formStateKey.currentState.validate()) {
                              _formStateKey.currentState.save();
                              signUp(_emailId, _password).then((user) {
                                if (user != null) {
                                  print('Registered Successfully.');
                                  setState(() {
                                    successMessage =
                                        'Registered Successfully.\nYou can now navigate to Login Page.';
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
                            'Login',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                (successMessage != ''
                    ? Text(
                        successMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.green),
                      )
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> signUp(email, password) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        setState(() {
          errorMessage = 'Email Id already Exist!!!';
        });
        break;
      default:
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
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.trim() != _passwordController.text.trim()) {
      return 'Password Mismatch!!!';
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

    Path yellowWave = Path();
    yellowWave.lineTo(sw, 0);
    yellowWave.lineTo(sw, sh * 0.1);
    yellowWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    yellowWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    yellowWave.close();
    paint.color = Colors.blue;
    canvas.drawPath(yellowWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw * 0.7, 0);
    greyWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    greyWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
