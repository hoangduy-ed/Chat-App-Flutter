import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods {
  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByPhone(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('Phone', isEqualTo: searchField)
        .getDocuments();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time',descending: true)
        .snapshots();
  }
  Future<void> addUserInfo(userData) async {
    Firestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

// Future<void> addUserInfo(userData, UserID) async{
//     Firestore.instance
//         .collection("users")
//         .document(UserID)
//         .collection("userid")
//         .add(userData)
//         .catchError((e){
//           print(e.toString());
//     });
// }

  Future<void> addMessage(String chatRoomId, chatMessageData)async {
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e){
          print(e.toString());
    });
  }
  getUserChats(String itIsMyName) async {
    return Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
