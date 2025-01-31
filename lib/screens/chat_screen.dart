import 'package:bigtable_connect/Auth/SharedPreferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chat;
  final String userKey;

  const ChatScreen(this.chat, this.userKey, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map> chats = [];
  TextEditingController textMessage = TextEditingController();
  late String userKey;
  late String email;
  final key1 = 'Email';
  late String firstName;
  late String lastName;
  late String userKey1;
  late String profileImage;
  bool isDataFetched = false;

  Future<void> loadData() async {
    if (isDataFetched) return;
    String? userEmail = await getData(key1);
    String? userFirstName = await getData("FirstName");
    String? userLastName = await getData("LastName");
    String? profileImage1 = await getData("ProfileImage");
    String? userkey = await getKey();
    setState(() {
      email = userEmail!;
      userKey1 = userkey!;
      firstName = userFirstName!;
      lastName = userLastName!;
      if (profileImage1 != null) {
        profileImage = profileImage1;
      } else {
        profileImage = "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media";
      }
      isDataFetched = true;
    });
  }

  Future<void> getChatData() async {
    // userKey = (await getKey())!;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('BigtableConnect/tblText');
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      chats.clear();

      // for (var entry in values.entries) {
      //   var key = entry.key;
      //   var value = entry.value;
      //   participantId = value["SenderId"] == userKey
      //       ? value["ParticipantId"]
      //       : value["SenderId"];
      //
      //   await getUserData(participantId);
      //
      //   // Exclude the logged-in user from chat list
      //   if (email != await getUserEmail()) {
      //     chats.add({
      //       'Key': key,
      //       'SenderId': value["SenderId"],
      //       'ParticipantId': value["ParticipantId"],
      //       'Firstname': firstname,
      //       'Lastname': lastname,
      //       'FCMToken': fcmToken,
      //       'Email': email,
      //       'ProfileImage': profileImage,
      //     });
      //   }
      // }
    }

    // setState(() {
    //   filteredChats = List.from(chats);
    // });
  }

  Future<void> sendMessage() async {
    print("Send message called");
    var message = textMessage.text;

    Query dbRef2 = FirebaseDatabase.instance
        .ref()
        .child('BigtableConnect/tblChat')
        .orderByChild("SenderId")
        .equalTo(email);

    await dbRef2.once().then((documentSnapshot) async {
      for (var x in documentSnapshot.snapshot.children) {
        Map data = x.value as Map;
        print(data);

        if (data['ParticipantId'] != widget.userKey) {
          return;
        }
      }
    });

    // Text content
    // Class id (from tblClasses) / chat id (from tblChat)
    // Sender id(from tblUser)
    // Date and time
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4D3E),
        leadingWidth: MediaQuery.of(context).size.width *
            0.22, // Adjust width for the back arrow and avatar
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_outlined,
                  color: Color(0xFF9C7945)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage: profileImage.isNotEmpty
                  ? NetworkImage(profileImage)
                  : const NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"),
              backgroundColor: const Color(0xFF9C7945),
            ),
          ],
        ),
        title: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatScreen(widget.chat),
            //   ),
            // );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$firstName $lastName",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C7945)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 14, color: Color(0xFF9C7945)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            builder: (context, snapshot) {
              return const SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              );
            },
            future: null,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B4D3E),
                borderRadius: BorderRadius.circular(50),
              ),
              height: MediaQuery.of(context).size.height * 0.075,
              child: TextField(
                controller: textMessage,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await sendMessage();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF9C7945),
                    ),
                  ),
                  hintText: "Type...",
                  hintStyle: const TextStyle(color: Color(0xFF9C7945)),
                ),
                style: const TextStyle(
                    color: Color(0xFF9C7945), fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
