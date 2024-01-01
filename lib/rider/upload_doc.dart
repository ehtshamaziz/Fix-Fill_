import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadDoc extends StatefulWidget {
  bool rider;
  bool shop;

   UploadDoc({ required this.rider, required this.shop});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {

  // bool imageExist=false;
  late String status;

  @override
  void initState() {
    super.initState();
    // if (imageExist==false) {
    //   checkStatus();
    //   setState(() {});
    //   // imageExist = true;
    // }
    checkGalleryPermission();
  }

  Future<bool> checkStatus() async {
    print("aaaaaaaaaaaaaaaaaaaa");
    print("aaaaaaaaaaaaaaaaaaaa");
  User? currentUser = FirebaseAuth.instance.currentUser;

  String userUid = currentUser!.uid;
    print("ddddddddddddddd");
    late DocumentSnapshot docSnapshot;
    if(widget.rider==true && widget.shop==false){
      // uploadFile();
       docSnapshot = await FirebaseFirestore.instance.collection('rider').doc(userUid).get();

    }
    else if(widget.shop==false && widget.rider==false){
      // uploadFileForStation(dataController);
       docSnapshot = await FirebaseFirestore.instance.collection('station').doc(userUid).get();

    }
    else if(widget.rider==false && widget.shop==true){
       docSnapshot = await FirebaseFirestore.instance.collection('shop').doc(userUid).get();


    }
    print("eeeeeeeeeeeeeeeeeeeeeeeeeee");

  if (docSnapshot.exists) {
    print("bbbbbbbbbbbbbb");
  // Document exists, check if the 'imageURL' field exists
  if (docSnapshot.data() != null) {
    print("cccccccccccccccccccccc");

    // imageExist=true;
  // 'imageURL' field exists in the document
  //    status=docSnapshot['status'];
  String imageURL = docSnapshot['imageURL'];
  print('Image URL: $imageURL');
  return true;

  } else {
    // imageExist=false;
  // 'imageURL' field does not exist in the document
  print('Image URL does not exist in the document.');
    return false;
  }
  } else {
  // Document does not exist
  print('Document does not exist for user with UID: $userUid');
  return false;

  }
    // setState(() {}); // Update the UI


  }
  Future<void> requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  void checkGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) {
      getImage();
      // Permission is granted, proceed
    } else {
      // Permission is not granted, request it
      await requestGalleryPermission();
    }
  }

  File? _image;
  final picker = ImagePicker();
  String? _uploadedFileURL;

  Future getImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String dataController) async {
    if (_image == null) return;
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      _uploadedFileURL = await storageReference.getDownloadURL();
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;
      await FirebaseFirestore.instance.collection('rider').doc(userUid).get();

      setState(() {
        // Save URL to Firestore under riders collection
        FirebaseFirestore.instance.collection('rider')
            .doc(userUid) // Replace with the rider's document ID
            .update({'imageURL': _uploadedFileURL,'description':dataController})
            .then((_) => print("Image URL added to rider's document"))
            .catchError((error) => print("Failed to add image URL: $error"));
      });
    }).catchError((error) {
      print(error);
    });
  }
  Future uploadFileForStation(String dataController) async {
    if (_image == null) return;
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      _uploadedFileURL = await storageReference.getDownloadURL();
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;
      await FirebaseFirestore.instance.collection('station').doc(userUid).get();

      setState(() {
        // Save URL to Firestore under riders collection
        FirebaseFirestore.instance.collection('station')
            .doc(userUid) // Replace with the rider's document ID
            .update({'imageURL': _uploadedFileURL,'description':dataController})
            .then((_) => print("Image URL added to Station's document"))
            .catchError((error) => print("Failed to add image URL: $error"));
      });
    }).catchError((error) {
      print(error);
    });
  }

  Future uploadFileForShop(String dataController) async {
    if (_image == null) return;
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      _uploadedFileURL = await storageReference.getDownloadURL();
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;
      await FirebaseFirestore.instance.collection('shop').doc(userUid).get();

      setState(() {
        // Save URL to Firestore under riders collection
        FirebaseFirestore.instance.collection('shop')
            .doc(userUid) // Replace with the rider's document ID
            .update({'imageURL': _uploadedFileURL,'description':dataController})
            .then((_) => print("Image URL added to shop's document"))
            .catchError((error) => print("Failed to add image URL: $error"));
      });
    }).catchError((error) {
      print(error);
    });
  }
  final _formkey=GlobalKey<FormState>();
  TextEditingController dataController = TextEditingController();
  @override

  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: checkStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else {
          bool imageExists = snapshot.data ?? false;
          return buildUploadScreen(imageExists);
        }
      },
    );
  }

  Widget buildUploadScreen(imageExists){
    late String name;
    if(widget.rider==true){
      name="rider";
    }else if(widget.shop==true){
      name= "shop";
    }else if(widget.shop==false){
      name="station";
    }
    // Check if image already exists
    print(imageExists);
    if (imageExists) {
      // If image already exists, display a specific message
      return Scaffold(
        appBar: AppBar(
          title: Text('Upload Data'),
        ),
        drawer: NavBar(name:name),
        body: Center(
          child: Text('Your profile is in review, please wait'),
        ),
      );
    } else {
      // If image does not exist, display the usual widgets for image selection and upload
      return Scaffold(
        appBar: AppBar(
          title: Text('Upload Data'),
        ),
        drawer: NavBar(name:name),
        body:Form(
        key: _formkey,
          child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(height: 50.h,),
              _image == null ? Text('No image selected.') : Container(
                  height: 200,
                  width: 250,
                  child: Image.file(_image!)),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Pick Image'),
              ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: 300.0,
                child: TextFormField(
                controller: dataController,
                maxLength: 40,
                maxLines: 1, // Restrict to a single line
                decoration: InputDecoration(
                  hintText: 'Enter Description (max 40 words)',
                 // Disable the default character counter
                ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your description';
    }
                }

              ))),
              _image == null ?Container():
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    if (widget.rider == true && widget.shop == false) {
                      uploadFile(dataController.text.trim());
                    }
                    else if (widget.shop == false && widget.rider == false) {
                      uploadFileForStation(dataController.text.trim());
                    }
                    else if (widget.rider == false && widget.shop == true) {
                      uploadFileForShop(dataController.text.trim());
                    }
                  }
                },
                  child: Text('Upload Data'),
                  ),
              _uploadedFileURL == null ? Container() : Text('File Uploaded, please wait.'),
            ],
          )),
        ),
      );
    }
  }
}
