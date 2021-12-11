import 'package:flutter/material.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'Contacts.dart';
import 'Info.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:this.getBody(),
          bottomNavigationBar: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
            currentIndex: this.selectedIndex,
            items: [
               BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                 title: Text("Tin Nhắn"),
           ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  title: Text("Danh Bạ"),
    ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.person),
                 title: Text("Thông Tin"),
    )
    ],
                onTap: (int index) {
               this.onTapHandler(index);
    },
    ),
    );
  }
  Widget getBody()  {
    if(this.selectedIndex == 0) {
      return ChatRoom();
    }
    else if(this.selectedIndex == 1) {
      return Contacts();
    }
    else{
      return Info();
    }
  }
  void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
  }