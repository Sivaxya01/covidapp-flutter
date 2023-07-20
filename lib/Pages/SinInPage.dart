import 'dart:async';
import 'dart:convert';

import 'package:blogapp/Pages/ForgetPassword.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignUpPage.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Profile/CreatProfile.dart';
import 'package:blogapp/Profile/MainProfile.dart';
import "package:flutter/material.dart";
import 'package:motion_toast/motion_toast.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

// import 'package:sensors_plus/sensors_plus.dart';

import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' as foundation;

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isNear = false;
  bool _isNearSec = true;
  Timer _timer;
  int _start;
  int number = 0;

  void startTimer() {
    _isNearSec = false;
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isNearSec = true;
            // timer.cancel();
          });
        } else {
          setState(() {
            print("Jiwan");
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // listenSensor();
    // TODO: implement initState
    _streamSubscriptions.add(
      ProximitySensor.events.listen(
        (int event) {
          setState(() {
            _isNear = (event > 0) ? true : false;
            print(number);
            if (_isNear == true && number < 100 && _isNearSec == true) {
              _start = 3;
              startTimer();
              number += 1;
              MotionToast.delete(
                      description:
                          const Text('you are moving your mobile phone'))
                  .show(context);
            }

            print('hello');
            //  for (final subscription in _streamSubscriptions) {
            //       subscription.cancel();
            //     };

            //  Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => WelcomePage(),
            // ));
            //  MotionToast.info(
            //             description:
            //                 const Text('you are moving your mobile phone'))
            //         .show(context);
          });
        },
      ),
    );
    // _streamSubscriptions.add(
    //   accelerometerEvents.listen(
    //     (AccelerometerEvent event) {
    //       setState(() {
    //         _accelerometerValues = <double>[event.x, event.y, event.z];
    //         if (event.x > 0)  {
    //           for (final subscription in _streamSubscriptions) {
    //             subscription.cancel();
    //           };
    //            Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => WelcomePage()));
    //         }
    //       });
    //     },
    //   ),
    // );
  }

  List<double> _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green[200]],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In with Email",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                usernameTextField(),
                SizedBox(
                  height: 15,
                ),
                passwordTextField(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "New User?",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });

                    //Login Logic start here
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                    };
                    var response =
                        await networkHandler.post("/user/login", data);

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output["token"]);
                      await storage.write(key: "token", value: output["token"]);
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    } else {
                      String output = json.decode(response.body);
                      setState(() {
                        validate = false;
                        errorText = output;
                        circular = false;
                      });
                    }

                    // login logic End here
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff00A86B),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                // Divider(
                //   height: 50,
                //   thickness: 1.5,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
  // @override
  // void initState() {
  //   // TODO: implement initState

  //   super.initState();
  //   detector = ShakeDetector.waitForStart(onPhoneShake: () {
  //     print('hello');
  //     Navigator.push(
  //                     context,
  //                           MaterialPageRoute(
  //                               builder: (context) => HomePage()));

  //     // Do stuff on phone shake
  //   });

  //   detector.startListening();

  // }

  //  @override
  // void dispose(){
  //   super.dispose();
  //   detector.stopListening();
  // }

  Widget usernameTextField() {
    return Column(
      children: [
        Text("Username"),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        Text("Password"),
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperStyle: TextStyle(
              fontSize: 14,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
