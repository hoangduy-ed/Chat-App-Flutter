import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({this.chatRoomId});
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
    super.initState();
  }
  Widget chatMessages(){
    return Expanded(
      child: StreamBuilder(
        stream: chats,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data.documents.length ,
                shrinkWrap: true,
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, index){
                  return MessageTile(
                        message: snapshot.data.documents[index].data["message"],
                        sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
                      );
              })
              : Container(
                child: CircularProgressIndicator()
            );
          },
      ),
    );
  }
  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic > chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .microsecondsSinceEpoch,

      };
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Chat"),
      ),
      body: Container(
        alignment: Alignment(0, 0.6),
        child: Column(
          children: <Widget> [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Color(0x5418BA8C),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Nhập tin nhắn....",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    // SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 5),
                          child: Icon(Icons.send)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  MessageTile({@required this.message, @required this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: sendByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :
              BorderRadius.only(
          topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: sendByMe ? [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ]:[
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ],
              )
          ),
          child: Text(message,
              style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300)),
        ),
    );
  }
}

