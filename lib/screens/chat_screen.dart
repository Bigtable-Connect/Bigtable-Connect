import 'dart:io';

import 'package:bigtable_connect/Auth/SharedPreferences.dart';
import 'package:bigtable_connect/Model/text_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Add flutter_pdfview package
import 'package:intl/intl.dart';

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
  final key1 = 'Email';
  late String email, firstname, lastname, fcmToken, profileImage;
  bool isDataFetched = false;
  FilePickerResult? result;
  String? fileType;
  String? filePathPreview;

  Future<void> loadData() async {
    if (isDataFetched) return;
    userKey = (await getKey())!;

    Query dbRef2 = FirebaseDatabase.instance
        .ref()
        .child('BigtableConnect/tblChat/${widget.chat}');

    await dbRef2.once().then((documentSnapshot) async {
      var data = documentSnapshot.snapshot.value as Map;
      if (data['ParticipantId'] == userKey) {
        await getUserData(data['SenderId']);
      } else {
        await getUserData(data['ParticipantId']);
      }
    });
    getChatData();
  }

  Future<void> getUserData(String userKey) async {
    Query dbRef2 = FirebaseDatabase.instance
        .ref()
        .child('BigtableConnect/tblUser/$userKey');

    await dbRef2.once().then((documentSnapshot) async {
      var data = documentSnapshot.snapshot.value as Map;
      email = data["Email"];
      firstname = data["FirstName"];
      lastname = data["LastName"];
      fcmToken = data["FCMToken"];
      profileImage = data['ProfileImage'] == ""
          ? "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"
          : data["ProfileImage"];
    });
  }

  void getChatData() {
    Query dbRefChatText = FirebaseDatabase.instance
        .ref()
        .child("BigtableConnect/tblText")
        .orderByChild("Class_or_ChatId")
        .equalTo(widget.chat);

    dbRefChatText.onValue.listen((event) {
      chats.clear();
      for (var i in event.snapshot.children) {
        Map data = i.value as Map;
        getUserData(data['SenderId']);

        // Parse and format the date-time
        String formattedDateTime = "";
        try {
          DateTime dateTime = DateTime.parse(data['DateTimeOfMessage']);
          formattedDateTime = DateFormat('hh:mm a | dd-MM-yy').format(dateTime);
        } catch (e) {
          formattedDateTime = data['DateTimeOfMessage']; // Fallback
        }

        if (data['SenderId'] == userKey) {
          chats.add({
            'TextContent': data['TextContent'],
            'DateTimeOfMessage': formattedDateTime,
            'SenderId': data['SenderId'],
            'Class_or_ChatId': data['Class_or_ChatId'],
            'Email': email,
            'Name': "You",
            'FcmToken': fcmToken,
            'ProfileImage': profileImage
          });
        } else {
          chats.add({
            'TextContent': data['TextContent'],
            'DateTimeOfMessage': formattedDateTime,
            'SenderId': data['SenderId'],
            'Class_or_ChatId': data['Class_or_ChatId'],
            'Email': email,
            'Name': "$firstname $lastname",
            'FcmToken': fcmToken,
            'ProfileImage': profileImage
          });
        }
      }
      setState(() {}); // This ensures UI refreshes
    });
    isDataFetched = true;
  }

  Future<void> pickFile() async {
    result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result!.files.single.path!;
      String fileName = result!.files.single.name;

      // Checking file type based on extension
      String extension = fileName.split('.').last.toLowerCase();

      // Logic to handle file preview
      if (extension == 'pdf') {
        // Handle PDF Preview
        setState(() {
          fileType = 'pdf';
          filePathPreview = filePath;
        });
      } else if (extension == 'jpg' ||
          extension == 'jpeg' ||
          extension == 'png') {
        // Handle Image Preview
        setState(() {
          fileType = 'image';
          filePathPreview = filePath;
        });
      } else if (extension == 'ppt' || extension == 'pptx') {
        // Handle PPT Preview
        setState(() {
          fileType = 'ppt';
          filePathPreview = filePath;
        });
      } else if (extension == 'doc' || extension == 'docx') {
        // Handle DOC Preview
        setState(() {
          fileType = 'doc';
          filePathPreview = filePath;
        });
      } else {
        // Handle Other File Types
        setState(() {
          fileType = 'other';
          filePathPreview = filePath;
        });
      }
    }

    setState(() {});
  }

  Future<void> sendMessage() async {
    var message = textMessage.text;
    DatabaseReference dbRef2 =
        FirebaseDatabase.instance.ref().child('BigtableConnect/tblText');

    TextModel textModel = TextModel(message, widget.chat.toString(), "",
        userKey, DateTime.now().toString());

    dbRef2.push().set(textModel.toJson());

    textMessage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (firstname.isNotEmpty) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: const Color(0xFF1B4D3E),
                leadingWidth: MediaQuery.of(context).size.width * 0.22,
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
                      backgroundImage: NetworkImage(profileImage),
                      backgroundColor: const Color(0xFF9C7945),
                    ),
                  ],
                ),
                title: Text(
                  "$firstname $lastname",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C7945)),
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  IconButton(
                    icon:
                        const Icon(Icons.attach_file, color: Color(0xFF9C7945)),
                    onPressed: () async {
                      await pickFile();
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        chats[index]['ProfileImage']),
                                    maxRadius: 25,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              chats[index]['Name'],
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              chats[index]['DateTimeOfMessage'],
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            )
                                          ],
                                        ),
                                        Text(
                                          chats[index]['TextContent'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B4D3E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: MediaQuery.of(context).size.height * 0.075 +
                          (result != null
                              ? MediaQuery.of(context).size.height * 0.34
                              : 0), // Adjust height based on file
                      child: Column(
                        children: [
                          if (result != null)
                            // Preview the file based on type
                            if (fileType == 'pdf')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: PDFView(
                                    filePath: filePathPreview,
                                  ),
                                ),
                              )
                            else if (fileType == 'image')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(filePathPreview!),
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else if (fileType == 'ppt')
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.slideshow,
                                    size: 100, color: Colors.white),
                              )
                            else if (fileType == 'doc')
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.document_scanner,
                                    size: 100, color: Colors.white),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.attach_file,
                                    size: 100, color: Colors.white),
                              ),
                          TextField(
                            controller: textMessage,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20),
                              border: InputBorder.none,
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
                              hintStyle:
                                  const TextStyle(color: Color(0xFF9C7945)),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF9C7945),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
