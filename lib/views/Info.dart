import 'package:chatapp/helper/Authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}
class _InfoState extends State<Info> {

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  changeUser() async {
  }
@override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myPhone = await HelperFunctions.getUserPhoneSharedPreference();
    print("${Constants.myPhone} hello ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("App Chat"),
          ),
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () {
                AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.logout)
              ),
            )
          ],
        ),
     body: Container(
       color: Colors.white,
       padding: EdgeInsets.symmetric(horizontal: 24),
       child: Padding(
         padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
         child:
         Column(
           children: [
             Spacer(),
             Form(
               child: Column(
                 children: [
                   TextFormField(
                     controller: usernameEditingController,
                     style: TextStyle(color: Colors.black),
                     validator: (val){
                       return val.isEmpty || val.length < 3 ? "Tên người dùng trên 3 kí tự" : null;
                     },
                     decoration: InputDecoration(
                       border: new OutlineInputBorder(
                           borderSide: new BorderSide(color: Colors.teal)),
                       prefixIcon: const Icon(
                         Icons.person,
                         color: Colors.green,
                       ),
                       labelText: "${Constants.myName}",
                     ),
                   ),
                   SizedBox(height: 25,),
                   TextFormField(
                     controller: phoneEditingController,
                     validator: (val){
                       return val.isEmpty || val.length < 9 || val.length > 11 ? "Vui lòng nhập lại số điện thoại" : null;
                     },
                     style: TextStyle(color: Colors.black),
                     decoration: InputDecoration(
                       border: new OutlineInputBorder(
                           borderSide: new BorderSide(color: Colors.teal)),
                       prefixIcon: const Icon(
                         Icons.phone,
                         color: Colors.green,
                       ),
                       labelText: "${Constants.myPhone}",
                     ),
                   ),
                   SizedBox(height: 25,),
                   TextFormField(
                     controller: emailEditingController,
                     style: TextStyle(color: Colors.black),
                     validator: (val){
                       return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                       null : "Vui lòng nhập lại Email";
                     },
                     decoration: InputDecoration(
                       border: new OutlineInputBorder(
                           borderSide: new BorderSide(color: Colors.teal)),
                       prefixIcon: const Icon(
                         Icons.email,
                         color: Colors.green,
                       ),
                       labelText: "${Constants.myEmail}",
                     ),
                   ),
                   SizedBox(height: 25,),
                 ],
               ),
             ),
             SizedBox(height: 25,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector(
                 onTap: (){
                   changeUser();
                 },
                 child: Container(
                   padding: EdgeInsets.symmetric(vertical: 24),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30),
                       gradient: LinearGradient(
                         colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
                       )),
                   width: MediaQuery.of(context).size.width,
                   child: Text(
                     "Thay Đổi",
                     style: TextStyle(color: Colors.black),
                     textAlign: TextAlign.center,
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
    );
  }
}

