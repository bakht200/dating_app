import 'package:cloud_firestore/cloud_firestore.dart';

class HelperFunction {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  // getAllUsers() async {
  //   String? userId = await UserSecureStorage.fetchToken();
  //   print(userId);
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .where('uid', isNotEqualTo: userId)
  //       .get();
  // }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('firstName', isEqualTo: searchField)
        .get();
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String? chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String? chatRoomId, chatMessageData) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String? itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  getUserInformation() async {
    List userData = [];

    try {
      // String? userId = await UserSecureStorage.fetchToken();

      await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: 'bp@gmail.com')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          userData.add(element);
        });
      });

      return userData;
    } catch (e) {
      return null;
    }
  }
}
