import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/search.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contacts> {
  Stream chatRooms;
  int selectedIndex = 0;
  String documentId ;

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants
                .myName}");
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("App Chat")),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.search)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  ),
                ],
              );
            })
            : Container();
      },
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }

}
