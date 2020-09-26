import 'package:ecommerce_buisness_tech/Category/categories.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'login_screens/login_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FacebookLogin facebookSignIn = new FacebookLogin();

void main() => runApp(new LoginOptions());

class LoginOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Ecommerce",
      home: MyLoginOption(),
    );
  }
}

class MyLoginOption extends StatefulWidget {
  @override
  _MyLoginOptionState createState() => new _MyLoginOptionState();
}

class _MyLoginOptionState extends State<MyLoginOption> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Login Now"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: BackgroundSignIn(),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                new Text(
                  "Login now.",
                  textScaleFactor: 3.0,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 150,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Categories()),
                    );
                  },
                  child: Text('Sign in with email'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                ),
                SizedBox(height: 30.0),
                FacebookSignInButton(
                  onPressed: _signIn,
                ),
                SizedBox(height: 30.0),
                GoogleSignInButton(onPressed: _gSignIn),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<FirebaseUser> _gSignIn() async {
  GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  FirebaseUser user = authResult.user;

  /*assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  if(user.uid == currentUser.uid){
      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyHomePage()));
    }

*/

  return user;
}

Future<FirebaseUser> _signIn() async {
  final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

  FacebookAccessToken myToken = result.accessToken;
  AuthCredential credential =
      FacebookAuthProvider.getCredential(accessToken: myToken.token);
  FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  /*  Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new DetailedScreen(detailsUser: userInfoDetails),
      ),
    );
   */
  return user;
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
    paint.color = Colors.lightBlueAccent;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
