import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corp_com/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/repositories/common_firebase_storage_repository.dart';
import '../../../common/utils/utils.dart';
import '../../../models/group.dart' as model;
import '../../../models/message.dart';
import '../controller/group_controller.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<UserModel> user) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < user.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'identifier',
              isEqualTo: user[i].identifier,
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'group/$groupId',
            profilePic,
          );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );
      // saving group info in to group path
      await firestore.collection('groups').doc(groupId).set(group.toMap());
      // saving each group id into users info to get which user uses which group
      final collectionReference = firestore.collection('users');
      List<String> uidAndOtherId = [auth.currentUser!.uid, ...uids];
      uidAndOtherId.forEach((String currentId) async {
        final documentReference = collectionReference.doc(currentId);
        final snapshot = await documentReference.get();
        final data = snapshot.data() as Map<String, dynamic>;
        List<String> groupIdList = [];
        if (data.containsKey('groupId') && data['groupId'] != null) {
          groupIdList = List<String>.from(data['groupId']);
        }
        groupIdList.add(groupId);
        await documentReference.update({'groupId': groupIdList});
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  getGroupUserInUse(BuildContext context) async {
    final userRef = await getUserDataFromSharedPreferences();
    String uid;
    if (userRef != null) {
      uid = userRef.uid;
    } else {
      uid = auth.currentUser!.uid;
    }
    int temp = 0;
    final totalUnread = ref.read(groupCounterProvider);
    var userData = await firestore.collection('users').doc(uid).get();
    var user = UserModel.fromMap(userData.data()!);
    var listOfGroupId = user.groupId;
    listOfGroupId.forEach((groupId) async {
     var temp2 = await groupCountUnreadMessageEach(groupId, context);
     temp += temp2.length;
     await totalUnread.setCounter(temp);
    });

  }

  Future<List<Message>> groupCountUnreadMessageEach(String groupId, BuildContext context) async {
    var querySnapshot = await firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .get();
    List<Message> messages = [];
    messages.clear();
    for (var document in querySnapshot.docs) {
      if (!Message.fromMap(document.data()).isSeen) {
        messages.add(Message.fromMap(document.data()));

      }
    }
    setGroupUnreadMessageIncrease(context, groupId, messages.length);
    return messages;
  }

  void setGroupChatMessageSeen(
      BuildContext context,
      String receiverUserId,
      String messageId,
      ) async {
    try {
      await firestore
          .collection('groups')
          .doc(receiverUserId)
          .collection('chats')
          .doc(messageId)
          .update({'isSeen': true});

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }


  setGroupUnreadMessageIncrease(
      BuildContext context,
      String groupId,
      int unreadCount,
      ) async {
    try {
      String path = 'groups/$groupId';
      DocumentReference docRef = firestore.doc(path);
      // check if the document exist
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        docRef.update({
          'unread': unreadCount,
        });
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}
