import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByPhone(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.documents[index].data["userName"],
          searchResultSnapshot.documents[index].data["userEmail"],
        );
        }
        ) : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId: chatRoomId,
      )
    ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Chat"),
      ),
      body: Container(
        color: Colors.white,
        child: isLoading ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) :  Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "search username ...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            labelText: 'User',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          initiateSearch();
                          },
                        child: Container(
                          height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            padding: EdgeInsets.all(12),
                            child:  Image(
                              image: AssetImage("assets/Image/download.jpeg"),
                              height: 1000,
                              width: 1000,
                              fit: BoxFit.cover,
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              userList()
            ],
          ),
        ),
      ),
    );
  }
}


