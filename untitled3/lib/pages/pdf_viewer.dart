import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key}) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {


  Future<void> securePdf() async {
    //Load the existing PDF document.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('credit_card_statement.pdf'));
    //Set the document security.
    document.security.userPassword = '1234';
    //Save and dispose the document.
    List<int> bytes = document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'secured.pdf');
  }

  Future<void> _launchPdf(List<int> bytes, String fileName) async {
    //Get the external storage directory
    Directory? directory = await getExternalStorageDirectory();
    //Get the directory path
    String path = directory!.path;
    //Create an empty file to write the PDF data
    File file = File('$path/$fileName');
    //Write the PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> restrictPermissions() async {
    //Load the existing PDF document.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('credit_card_statement.pdf'));
    //Create document security.
    PdfSecurity security = document.security;
    //Set the owner password for the document.
    security.ownerPassword = 'owner@123';
    //Set various permission.
    security.permissions.addAll(<PdfPermissionsFlags>[
      PdfPermissionsFlags.fullQualityPrint,
      PdfPermissionsFlags.print,
      PdfPermissionsFlags.fillFields,
      PdfPermissionsFlags.copyContent
    ]);
    //Save and dispose the document.
    List<int> bytes = document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'permissions.pdf');
  }

  Future<void> decryptPDF() async {
    //Load the PDF document with permission password.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('secured.pdf'),
        password: 'owner@123');
    //Get the document security.
    PdfSecurity security = document.security;
    //Set owner and user passwords are empty string.
    security.userPassword = '';
    security.ownerPassword = '';
    //Clear the security permissions.
    security.permissions.clear();
    //Save and dispose the document.
    List<int> bytes = document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'unsecured.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion Flutter PdfViewer'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(onPressed: securePdf, child: Text('Encrypt PDF')),
              FlatButton(
                  onPressed: restrictPermissions,
                  child: Text('Restrict Permissions')),
              FlatButton(onPressed: decryptPDF, child: Text('Decrypt PDF')),
            ]),
      ),
    );
  }
}
