import 'package:chatapp/views/Home.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'helper/Authenticate.dart';
import 'helper/helperfunctions.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp>{
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }


  @override
  // ignore: non_constant_identifier_names
  Widget build(BuildContext){
    return Sizer(
        builder: (context, orientation, deviceType)
    {
      return MaterialApp(
        // home: SignIn(),
          home: userIsLoggedIn != null ?  userIsLoggedIn ? Home() : Authenticate()
              : Container(
                   child: Center(
                      child: Authenticate(),
          )
          )

      );
    }
      );

  }
}






