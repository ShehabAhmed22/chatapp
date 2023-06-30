import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
late User signInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = "chat_screen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String? messageText;
  final controlMessages = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
  }

  void currentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(signInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _fireStore.collection("messages").get();
  //   for (var mess in messages.docs) {
  //     print(mess.data());
  //   }
  // }
  // void messageStream() async {
  //   await for (var snapShot in _fireStore.collection("messages").snapshots()) {
  //     for (var mess in snapShot.docs) {
  //       print(mess.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // messageStream();
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
        backgroundColor: Colors.orange[800],
        title: Row(
          children: [
            Image.asset(
              "images/logo.png",
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Message"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controlMessages,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controlMessages.clear();
                      _fireStore.collection("messages").add({
                        "sender": messageText,
                        "receiver": signInUser.email,
                        "time":FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  final String? sender;
  final String? receiver;
  final bool isMe;

  const MessageLine(
      {super.key, this.sender, this.receiver, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            "$receiver",
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
            elevation: 5,
            borderRadius:isMe? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)):const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: isMe?Colors.blue[800]:Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "$sender",
                style:   TextStyle(fontSize: 17, color: isMe ? Colors.white:Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("messages").orderBy("time").snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final textMessageSender = message.get("sender");
            final textMessageReceiver = message.get("receiver");
            final currentUser = signInUser.email;
            final showMessage = MessageLine(
              sender: textMessageSender,
              receiver: textMessageReceiver,
              isMe: currentUser == textMessageReceiver,
            );

            messageWidgets.add(showMessage);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        });
  }
}
