import 'dart:io';

import 'package:bigtable_connect/Auth/SharedPreferences.dart';
import 'package:bigtable_connect/Model/media_model.dart';
import 'package:bigtable_connect/Model/text_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Add flutter_pdfview package
import 'package:intl/intl.dart';

import '../Notification/personal_chat_notification.dart';
import '../secondFirebaseInitialization.dart';
import 'PDFViewerScreen.dart';

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
  late String resFirstname, resLastname;
  bool isDataFetched = false;
  FilePickerResult? result;
  String? fileType, mediaType;
  String? filePathPreview;
  late String fileName;
  late String dateTimeOfMessage;

  Future<void> loadData() async {
    if (isDataFetched) return;
    userKey = (await getKey())!;
    resFirstname = (await getData("FirstName"))!;
    resLastname = (await getData("LastName"))!;

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

  Future<void> getUserData(String userKey1) async {
    Query dbRef2 = FirebaseDatabase.instance
        .ref()
        .child('BigtableConnect/tblUser/$userKey1');

    await dbRef2.once().then((documentSnapshot) async {
      var data = documentSnapshot.snapshot.value as Map;
      if (userKey1 == userKey) {
        email = data["Email"];
        firstname = data["FirstName"];
        lastname = data["LastName"];
        profileImage = data['ProfileImage'] == ""
            ? "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"
            : data["ProfileImage"];
      } else {
        email = data["Email"];
        resFirstname = data["FirstName"];
        resLastname = data["LastName"];
        fcmToken = data["FCMToken"];
        profileImage = data['ProfileImage'] == ""
            ? "https://firebasestorage.googleapis.com/v0/b/arogyasair-b7bb5.appspot.com/o/ProfilePicture%2FDefault.webp?alt=media"
            : data["ProfileImage"];
      }
    });
  }

  void getChatData() {
    Query dbRefChatText = FirebaseDatabase.instance
        .ref()
        .child("BigtableConnect/tblText")
        .orderByChild("Class_or_ChatId")
        .equalTo(widget.chat);

    dbRefChatText.onValue.listen((event) async {
      chats.clear();
      for (var i in event.snapshot.children) {
        Map data = i.value as Map;

        // Parse and format the date-time
        String formattedDateTime = "";
        try {
          DateTime dateTime = DateTime.parse(data['DateTimeOfMessage']);
          formattedDateTime = DateFormat('hh:mm a | dd-MM-yy').format(dateTime);
        } catch (e) {
          formattedDateTime = data['DateTimeOfMessage']; // Fallback
        }

        String? mediaURL;

        if (data['MediaId'] != null) {
          mediaURL = await fetchMediaURL(data['MediaId']);
        }

        getUserData(data['SenderId']);
        if (data['SenderId'] == userKey) {
          chats.add({
            'TextContent': data['TextContent'],
            'DateTimeOfMessage': formattedDateTime,
            'SenderId': data['SenderId'],
            'Class_or_ChatId': data['Class_or_ChatId'],
            'MediaURL': mediaURL,
            'MediaType': mediaType,
            'Email': email,
            'Name': "You",
            'ProfileImage': profileImage
          });
        } else {
          chats.add({
            'TextContent': data['TextContent'],
            'DateTimeOfMessage': formattedDateTime,
            'SenderId': data['SenderId'],
            'Class_or_ChatId': data['Class_or_ChatId'],
            'MediaURL': mediaURL,
            'MediaType': mediaType,
            'Email': email,
            'Name': "$resFirstname $resLastname",
            'ProfileImage': profileImage
          });
        }
      }
      setState(() {
        isDataFetched = true;
      }); // This ensures UI refreshes
    });
  }

  Future<String?> fetchMediaURL(String mediaId) async {
    User? user = FirebaseAuth.instance.currentUser;
    late String mediaURL;

    // Initialize secondary Firebase app and sign in anonymously
    await FirebaseAuth.instanceFor(
      app: await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDxt2_HAugXvbs-25Lyqf00Qc7J2LMucL0',
          appId: '1:586592318920:android:75285b5ac0dbce88c53cfd',
          messagingSenderId: '586592318920',
          projectId: 'arogyasair-b7bb5',
          databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
          storageBucket: 'arogyasair-b7bb5.appspot.com',
        ),
      ),
    ).signInAnonymously();

    if (user != null) {
      DatabaseReference dbMedia = FirebaseDatabase.instance
          .ref()
          .child("BigtableConnect/tblMedia/$mediaId");

      // Wait for the snapshot
      DataSnapshot snapshot = await dbMedia.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map;
        var name = data['MediaName'];
        mediaType = data['MediaType'];

        // Reference to the file in Firebase Storage
        final Reference ref = FirebaseStorage.instanceFor(
                app: InitializeSecondProject.secondaryApp)
            .ref('BigtableConnect/Media/${widget.chat}/$name');

        // Wait for the download URL
        mediaURL = await ref.getDownloadURL();
        return mediaURL;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<void> pickFile() async {
    result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result!.files.single.path!;
      fileName = result!.files.single.name;

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

    String? mediaId;

    DateTime dateTime = DateTime.parse(DateTime.now().toString());
    var formattedDateTime = DateFormat('hh:mm_a_dd-MM-yy').format(dateTime);

    dateTimeOfMessage = formattedDateTime;

    if (result != null) {
      mediaId = await uploadMedia();
    }

    TextModel textModel = TextModel(
        message, widget.chat.toString(), mediaId, userKey, dateTimeOfMessage);

    dbRef2.push().set(textModel.toJson());

    textMessage.clear();
    result = null;
    var name = "$firstname $lastname";
    print(fcmToken);
    personalChatNotification(fcmToken: fcmToken, name: name);
  }

  Future<String> uploadMedia() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("BigtableConnect/tblMedia");

    // If no existing chat, create a new chat
    DatabaseReference newChatRef = dbRef.push(); // Generates a unique key
    String mediaID = newChatRef.key!; // Store the generated key

    var filename = "$firstname-$dateTimeOfMessage";

    MediaModel mediaModel = MediaModel(
        filename, fileType!, widget.chat, userKey, dateTimeOfMessage);

    newChatRef.set(mediaModel.toJson());

    Reference firebaseStorageRef =
        FirebaseStorage.instanceFor(app: InitializeSecondProject.secondaryApp)
            .ref()
            .child("BigtableConnect/Media/${widget.chat}/$filename");
    firebaseStorageRef.putFile(File(filePathPreview!));

    return mediaID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (resFirstname.isNotEmpty) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: const Color(0xFF1B4D3E),
                leadingWidth: MediaQuery.of(context).size.width * 0.24,
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
                  "$resFirstname $resLastname",
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
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        if (chats[index]['MediaURL'] != null)
                                          chats[index]['MediaType'] == 'pdf'
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20), // Adjust border radius
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PDFViewerScreen(
                                                            pdfUrl: chats[index]
                                                                [
                                                                'MediaURL'], // Pass the Firebase URL
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Center(
                                                        child: Text(
                                                            "Tap to Open PDF")),
                                                  ),
                                                )
                                              : chats[index]['MediaType'] ==
                                                      'image'
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20), // Adjust radius as needed
                                                      ),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      // Ensures the image follows the border radius
                                                      child: Image.network(
                                                        chats[index]
                                                            ['MediaURL'],
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Icon(
                                                      chats[index][
                                                                  'MediaType'] ==
                                                              'ppt'
                                                          ? Icons.slideshow
                                                          : chats[index][
                                                                      'MediaType'] ==
                                                                  'doc'
                                                              ? Icons
                                                                  .document_scanner
                                                              : Icons
                                                                  .attach_file,
                                                      size: 100,
                                                      color: Colors.white,
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
                        mainAxisSize: MainAxisSize.min,
                        // Ensures it takes only needed space
                        children: [
                          if (result != null)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: fileType == 'pdf'
                                        ? PDFView(filePath: filePathPreview)
                                        : fileType == 'image'
                                            ? Image.file(
                                                File(filePathPreview!),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                fileType == 'ppt'
                                                    ? Icons.slideshow
                                                    : fileType == 'doc'
                                                        ? Icons.document_scanner
                                                        : Icons.attach_file,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xFF1B4D3E),
                                    child: IconButton(
                                      color: const Color(0xFF9C7945),
                                      onPressed: () {
                                        setState(() {
                                          result = null;
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
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
                            ),
                          ),
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
