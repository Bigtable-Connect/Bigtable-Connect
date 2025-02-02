import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl; // The URL to the PDF

  const PDFViewerScreen({required this.pdfUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: double.infinity,
        child: SfPdfViewer.network(pdfUrl, key: pdfViewerKey,),
      ),
    );
  }
}
