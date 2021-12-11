import 'package:chatapp/dialog/msg_diaglog.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/Home.dart';
import 'package:chatapp/views/forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);





  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });


      await authService.signInWithEmailAndPassword
        (emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(emailEditingController.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);
          HelperFunctions.saveUserPhoneSharedPreference(
              userInfoSnapshot.documents[0].data["Phone"]);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          setState(() {
            MsgDialog.showMsgDialog(context, "Vui Lòng Nhập Lại ", "Sai Email hoặc Mật Khẩu");
            isLoading = false;
            //show snackbar
          });
        }
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("App Chat"),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 30, 40),
          color: Colors.white,
          constraints: BoxConstraints.expand(),
          child: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget> [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                          child: Center(
                            child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    color: Color(0xd8d8d8)
                                ),
                                padding: EdgeInsets.all(15),
                                // child: FlutterLogo()
                              child: Image(
                                image: AssetImage("assets/icon/appstore.png"),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            )
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val)
                                        ? null
                                        : "Email không hợp lệ";
                                  },
                                  controller: emailEditingController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                  )
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    return val.length > 6
                                        ? null
                                        : "Mật khẩu không hợp lệ";
                                  },
                                  style: TextStyle(color: Colors.black),
                                  controller: passwordEditingController,
                                  // decoration: textFieldInputDecoration("Password"),
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            // ignore: deprecated_member_use
                            child:  RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8))),
                              onPressed: signIn,
                              child: Text("Đăng Nhập",
                                style: TextStyle(fontSize: 20, color: Colors.white),),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text("Tạo Tài Khoản", style: TextStyle(
                                    fontSize: 15.0, color: Colors.blue,),),
                                  onTap:() => widget.toggleView,
                                ),
                                GestureDetector(
                                  child: Text("Quên Mật Khẩu?", style: TextStyle(
                                      fontSize: 15.0, color: Colors.blue),),
                                  onTap: () {
                                    Navigator.push(
                                         context,
                                          MaterialPageRoute(
                                             builder: (context) => ForgotPassword()));
                                 },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        )
    );
  }
}
