import 'package:blogapp/Blog/addBlog.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/MainProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'Pages/LoadingPage.dart';
import 'Pages/WelcomePage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shake/shake.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: const Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            importance: NotificationImportance.High,
            enableVibration: true)
      ]);
   runApp(MyApp());
}
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  // StreamSubscription<dynamic> _streamSubscriptions;
  // Future<void> listenSensor() async {
  //   print("hello");
  //   FlutterError.onError = (FlutterErrorDetails details) {
  //     if (foundation.kDebugMode) {
  //       FlutterError.dumpErrorToConsole(details);
  //     }
  //   };
  //   // _streamSubscription= ProximitySensor.events.listen((int event) {
  //   //   setState(() {
  //   //     print("hello");
  //   //     Navigator.of(context).push(MaterialPageRoute(
  //   //         builder: (context) => WelcomePage(),
  //   //       ));
        
        
  //   //     // _isNear = (event > 0) ? true : false;
  //   //   });
  //   // });
    
  //   _streamSubscriptions=
  //     ProximitySensor.events.listen(
  //       (int event) {
  //         setState(() {
  //          print('hello');
  //          MotionToast.info(
  //                     description:
  //                         const Text('you are moving your mobile phone'))
  //                 .show(context); 
  //         });
  //       },
      
  //   );
  // }
  
  Widget page = LoadingPage();
  final storage = FlutterSecureStorage();
  ShakeDetector detector;

  
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // listenSensor();
    checkLogin();
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   _streamSubscription.cancel();
  // }
  // Future<void> listenSensor() async {
  //   FlutterError.onError = (FlutterErrorDetails details) {
  //     if (foundation.kDebugMode) {
  //       FlutterError.dumpErrorToConsole(details);
  //     }
  //   };
    
  //   });
  // }
  
  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: page,
    );
  }
}
