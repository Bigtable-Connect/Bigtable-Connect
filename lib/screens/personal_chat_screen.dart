import 'package:bigtable_connect/screens/chat_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Auth/SharedPreferences.dart';
import '../Model/chat_model.dart';

class PersonalCharScreen extends StatefulWidget {
  const PersonalCharScreen({super.key});

  @override
  State<PersonalCharScreen> createState() => _PersonalCharScreenState();
}

class _PersonalCharScreenState extends State<PersonalCharScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> filteredChats = []; // New list for filtered data
  List<Map> chats = [];
  late String userKey;
  late String email, firstname, lastname, fcmToken, profileImage;
  FocusNode searchFocusNode = FocusNode();
  late String participantId;

  Future<void> getUserKey() async {
    userKey = (await getKey())!;
  }

  Future<void> getChatData() async {
    userKey = (await getKey())!;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('BigtableConnect/tblChat');
    dbRef.once().then(
      (value) async {
        for (var i in value.snapshot.children) {
          var key = i.key;
          var data = i.value as Map;
          if (data['ParticipantId'] == userKey || data['SenderId'] == userKey) {
            if (data['ParticipantId'] == userKey) {
              participantId = data["SenderId"];

              await getUserData(participantId);

              // Exclude the logged-in user from chat list
              // if (email != await getUserEmail()) {
              chats.add({
                'Key': key,
                'SenderId': data["SenderId"],
                'ParticipantId': data["ParticipantId"],
                'Firstname': firstname,
                'Lastname': lastname,
                'FCMToken': fcmToken,
                'Email': email,
                'ProfileImage': profileImage,
              });
              // }
            } else if(data['SenderId'] == userKey) {
              participantId = data["ParticipantId"];

              await getUserData(participantId);

              // Exclude the logged-in user from chat list
              // if (email != await getUserEmail()) {
              chats.add({
                'Key': key,
                'SenderId': data["SenderId"],
                'ParticipantId': data["ParticipantId"],
                'Firstname': firstname,
                'Lastname': lastname,
                'FCMToken': fcmToken,
                'Email': email,
                'ProfileImage': profileImage,
              });
              // }
            }
          }
        }
        setState(() {
          filteredChats = List.from(chats);
        });
      },
    );
  }

  Future<void> getUsersByEmail(String query) async {
    String loggedInEmail = await getUserEmail(); // Get logged-in user's email
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('BigtableConnect/tblUser');
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      filteredChats.clear();

      for (var entry in values.entries) {
        var user = entry.value;
        String userEmail = user["Email"] as String;

        if (userEmail.toLowerCase().contains(query.toLowerCase()) &&
            userEmail != loggedInEmail) {
          filteredChats.add({
            'Key': entry.key,
            'Email': userEmail,
            'Firstname': user["FirstName"],
            'Lastname': user["LastName"],
            'FCMToken': user["FCMToken"],
            'ProfileImage': user["ProfileImage"],
          });
        }
      }
    }

    setState(() {}); // Refresh UI
  }

// Helper function to get logged-in user's email
  Future<String> getUserEmail() async {
    return (await getData(
        "Email"))!; // Replace with your function to fetch email from SharedPreferences
  }

  Future<void> getUserData(String userKey) async {
    Query dbRef2 = FirebaseDatabase.instance
        .ref()
        .child('BigtableConnect/tblUser/$userKey');

    await dbRef2.once().then((documentSnapshot) async {
      var data = documentSnapshot.snapshot.value as Map;
      // if(data["Email"] != email){
      email = data["Email"];
      firstname = data["FirstName"];
      lastname = data["LastName"];
      fcmToken = data["FCMToken"];
      profileImage = data["ProfileImage"];
      // }
    });
  }

  // Filter students based on email input

  void filterChats(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredChats = List.from(chats);
      });
    } else {
      getUsersByEmail(query);
    }
  }

  @override
  void initState() {
    super.initState();
    getChatData(); // Load chat data once when the screen opens
  }

  Future<void> createChat(
      String senderID, String participantID, Map chat) async {
    DatabaseReference dbRefChat =
    FirebaseDatabase.instance.ref().child('BigtableConnect/tblChat');

    // Query for existing chat
    Query query = dbRefChat.orderByChild('SenderId');
    query.once().then((snapshot) async {
      if (snapshot.snapshot.value != null) {
        Map data = snapshot.snapshot.value as Map;

        for (var key in data.keys) {
          var chatData = data[key];

          if ((chatData['SenderId'] == senderID &&
              chatData['ParticipantId'] == participantID) ||
              (chatData['SenderId'] == participantID &&
                  chatData['ParticipantId'] == senderID)) {
            // Chat exists, navigate to chat screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  key, // Existing chat key
                  userKey, // User key
                ),
              ),
            );
            return;
          }
        }
      }

      // If no existing chat, create a new chat
      DatabaseReference newChatRef = dbRefChat.push(); // Generates a unique key
      String newChatID = newChatRef.key!; // Store the generated key

      ChatModel chatModel = ChatModel(senderID, participantID);

      newChatRef.set(chatModel.toJson()).then((_) {
        // Navigate using the new chat ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              newChatID, // Pass the newly created chat ID
              userKey, // Pass the user key
            ),
          ),
        );
      }).catchError((e) {
        if (kDebugMode) {
          print("Error creating new chat: $e");
        }
      });
    }).catchError((e) {
      if (kDebugMode) {
        print("Error querying chats: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // testMethod();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4D3E),
        title: const Text(
          "Personal Chat",
          style: TextStyle(
            color: Color(0xFF9C7945),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF9C7945),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.088,
            child: Container(
              margin: const EdgeInsets.all(10),
              // Add margin around the search box
              decoration: BoxDecoration(
                color: const Color(0xFF1B4D3E),
                // Background color for the search box
                borderRadius: BorderRadius.circular(30),
                // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9C7945).withOpacity(0.6),
                    // Light shadow effect
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // Position of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 2), // Inner padding
                child: CupertinoSearchTextField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  autofocus: false,
                  placeholder: "Search by Email...",
                  // Custom placeholder text
                  placeholderStyle: const TextStyle(
                    color: Color(0xFF9C7945), // Placeholder text color
                    fontSize: 16, // Font size
                  ),
                  style: const TextStyle(
                    color: Color(0xFF9C7945), // Input text color
                    fontSize: 16, // Font size
                  ),
                  prefixIcon: const Icon(
                    Icons.search, // Custom search icon
                    color: Color(0xFF9C7945), // Icon color
                  ),
                  suffixIcon: const Icon(
                    Icons.clear, // Clear button icon
                    color: Color(0xFF9C7945),
                  ),
                  autocorrect: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Rounded border
                  ),
                  onChanged: (String value) {
                    filterChats(value); // Call filter function
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: searchController.text.isEmpty
                ? (filteredChats.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          var chat = filteredChats[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(chat['Key'], userKey),
                                ),
                              );
                            },
                            title: Text(
                                "${chat['Firstname']} ${chat['Lastname']}"),
                            subtitle: Text(chat['Email']),
                            leading: CircleAvatar(
                              backgroundImage: chat['ProfileImage'] != null &&
                                      chat['ProfileImage'].isNotEmpty
                                  ? NetworkImage(chat['ProfileImage'])
                                  : const NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(searchFocusNode);
                          },
                          child: const Text("Start new chat"),
                        ),
                      ))
                : (filteredChats.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          var chat = filteredChats[index];
                          return ListTile(
                            onTap: () {
                              createChat(userKey, chat['Key'], chat);
                            },
                            title: Text(
                                "${chat['Firstname']} ${chat['Lastname']}"),
                            subtitle: Text(chat['Email']),
                            leading: CircleAvatar(
                              backgroundImage: chat['ProfileImage'] != null &&
                                      chat['ProfileImage'].isNotEmpty
                                  ? NetworkImage(chat['ProfileImage'])
                                  : const NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(searchFocusNode);
                          },
                          child: const Text("Start new chat"),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
