import 'package:chatapp/services/auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPassword  createState() => _ForgotPassword ();
}

class _ForgotPassword extends State<ForgotPassword> {
  String _email;
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password'),),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email'
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text('Send Request'),
                  onPressed: () {
                    auth.resetPass(_email);
                    Navigator.of(context).pop();
                  },
                  // color: Theme.of(context).accentColor,
                  color: Colors.blue,
                ),
              ],
            ),
          ],),
      ),
    );
  }
}