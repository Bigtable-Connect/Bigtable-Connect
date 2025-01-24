import 'package:bigtable_connect/secondFirebaseInitialization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imagePath = "";
  Future<void> getImage() async{
    // Reference to the PDF in Firebase Storage
    final Reference ref = FirebaseStorage.instanceFor(app: InitializeSecondProject.secondaryApp).ref('logo-color.png');
    // Generate a signed URL valid for 1 hour (3600 seconds)
    imagePath = await ref.getDownloadURL();
    if (kDebugMode) {
      print("imagePath $imagePath");
    }
  }
  @override
  Widget build(BuildContext context) {
    getImage();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Center(
        child: Text(imagePath),
      ),
    );
  }
}
