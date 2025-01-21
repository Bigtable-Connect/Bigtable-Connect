import 'package:bigtable_connect/secondFirebaseInitialization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageFetchTest extends StatefulWidget {
  const ImageFetchTest({super.key});

  @override
  State<ImageFetchTest> createState() => _ImageFetchTestState();
}

class _ImageFetchTestState extends State<ImageFetchTest> {
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
    return const Placeholder();
  }
}
