import 'package:chatapp/dialog/msg_diaglog.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);


  // SignIn(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final userId = Firestore.instance;

  singUp() async {

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });


      await authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result){
            if(result != null){
              Map<String,String> userDataMap = {
                "userName": usernameEditingController.text,
                "userEmail": emailEditingController.text,
                "Phone": phoneEditingController.text,
                "Id " : userId.collection('users').document().documentID.toString()
              };
              databaseMethods.addUserInfo(userDataMap);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);
              HelperFunctions.saveUserPhoneSharedPreference(phoneEditingController.text);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Home()
              ));
            }
            else {
              setState(() {
                MsgDialog.showMsgDialog(context, "Vui Lòng Nhập Lại", "Tài khoản đã được sử dụng");
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
    return Scaffold(
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
                            color: Color(0xffd8d8d8)
                        ),
                        padding: EdgeInsets.all(15),
                        child: FlutterLogo()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: usernameEditingController,
                        validator: (val){
                          return val.isEmpty || val.length < 3 ? "Tên người dùng trên 3 kí tự" : null;
                          },
                        decoration: InputDecoration(
                          labelText: "Họ và Tên",
                        ),
                      ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: phoneEditingController,
                          validator: (val){
                            return val.isEmpty || val.length < 9 || val.length > 11 ? "Vui lòng nhập lại số điện thoại" : null;
                            },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Số Điện Thoại",
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          style: TextStyle(color: Colors.black),
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Vui lòng nhập lại Email";
                            },
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          controller: passwordEditingController,
                          validator:  (val){
                            return val.length < 6 ? "Password phải có 6 kí tự" : null;
                            },
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
                              onPressed: singUp,
                              child: Text("Đăng Kí",
                                style: TextStyle(fontSize: 20, color: Colors.white),),
                            ),
                          ),
                        ),
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                "Bạn đã có tài khoản? ",
                                style: TextStyle(color: Colors.blue),
                              ),
                               GestureDetector(
                                 // ignore: unnecessary_statements
                                 onTap: () {widget.toggleView;
                                 },
                                 child: Text(
                                 "Đăng Nhập",
                                 style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 16,
                                     decoration: TextDecoration.underline),
                               ),),
    ]),
                            ),]),),),]),),),));
  }
}
