// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class TableInfo extends StatefulWidget {
//   @override
//   _TableState createState() => _TableState();
// }
//
// class _TableState extends State<TableInfo> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseUser user;
//
//   @override
//   void initState() {
//     super.initState();
//     initUser();
//   }
//
//   initUser() async {
//     user = await _auth.currentUser();
//     setState(() {
//       print(user.email);
//       print(user.displayName);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("this is an appbar yaay!"),
//       ),
//       drawer: Drawer(
//         elevation: 10.0,
//         child: ListView(
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Text("${user?.displayName}"),
//               accountEmail: Text("${user?.email}"),
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.fill,
//                   image: NetworkImage("${user?.photoUrl}"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Container(),
//       ),
//     );
//   }
// }