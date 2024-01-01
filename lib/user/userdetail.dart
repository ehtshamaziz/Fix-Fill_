// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fix_fill/model/ListedUsersModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';




class UserDetailsScreen extends StatefulWidget {
  String name;
  UserDetailsScreen({required this.name});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String email="";





  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    checkGalleryPermission();
    // final cred = EmailAuthProvider.credential(
    //   email: user!.email!,
    //   password: currentPassword,
    // );
    if (user != null) {
      email = user.email ?? '';
      _emailController.text =
          user.email ?? ''; // Set the email in the text field
      // _passwordController.text=user.password??'';
      int indexOfUnderscore = email.indexOf("_");

      // Check if "_" is found
      if (indexOfUnderscore != -1) {
        // Use substring to get the part of the string after "_"
        String result = email.substring(indexOfUnderscore + 1);

        email=result;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       // Update email
  //       if (_emailController.text.isNotEmpty) {
  // Future<void> _updateUserDetails() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       // Update email
  //       if (_emailController.text.isNotEmpty) {
  //         await user.updateEmail(_emailController.text);
  //       }
  //
  //       // Update password
  //       if (_passwordController.text.isNotEmpty) {
  //         await user.updatePassword(_passwordController.text);
  //       }
  //
  //       // Show a success message
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User details updated successfully")));
  //     }
  //   } catch (e) {
  //     // Handle errors, e.g., show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating user details: $e")));
  //   }
  // }
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
  Future uploadFile({required String name}) async {
    if (_image == null) return;
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      _uploadedFileURL = await storageReference.getDownloadURL();
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;
      await FirebaseFirestore.instance.collection(name).doc(userUid).get();

      setState(() {
        // Save URL to Firestore under riders collection
        FirebaseFirestore.instance.collection(name)
            .doc(userUid) // Replace with the rider's document ID
            .update({'imageProfileURL': _uploadedFileURL})
            .then((_) => print("Image URL added to ${name} document"))
            .catchError((error) => print("Failed to add image URL: $error"));
      });
    }).catchError((error) {
      print(error);
    });
  }

  late String imageURL="";
  Future<bool> checkStatus() async {
    print("aaaaaaaaaaaaaaaaaaaa");
    print("aaaaaaaaaaaaaaaaaaaa");
    User? currentUser = FirebaseAuth.instance.currentUser;

    String userUid = currentUser!.uid;
    print("ddddddddddddddd");
    late DocumentSnapshot docSnapshot;
    // if(widget.name=="rider"){
    //   uploadFile(name:"rider");
      docSnapshot = await FirebaseFirestore.instance.collection(widget.name).doc(userUid).get();
  uploadFile(name:widget.name);
    //
    // }
    // else if(widget.name=="station"){
    //   uploadFile(name:"station");
    //
    //   // uploadFileForStation();
    //   docSnapshot = await FirebaseFirestore.instance.collection('station').doc(userUid).get();
    //
    // }
    // else if(widget.name=="shop"){
    //   uploadFile(name:"shop");
    //
    //   docSnapshot = await FirebaseFirestore.instance.collection('shop').doc(userUid).get();
    //
    //
    // }
    // else if(widget.name=="users"){
    //   uploadFile(name:"users");
    //
    //   docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    //
    //
    // }
    print("eeeeeeeeeeeeeeeeeeeeeeeeeee");

    if (docSnapshot.exists) {
      print("bbbbbbbbbbbbbb");
      // Document exists, check if the 'imageURL' field exists
      if (docSnapshot.data() != null) {
        print("cccccccccccccccccccccc");

        // imageExist=true;
        // 'imageURL' field exists in the document
        //    status=docSnapshot['status'];
        imageURL = docSnapshot['imageProfileURL'];
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
  @override
  Widget build(BuildContext context) {
    print("JJJJJJ ${widget.name}");
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
  Widget buildUploadScreen(imageExists) {
    print(_passwordController.text);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text("Email: ${email}"
              // controller: _emailController,
              // decoration: InputDecoration(labelText: "Email"),
            ),),
            imageURL==""?Container(

                // ),
            // Image(image: AssetImage('assets/GasStation.jpg')),
            child:_image == null ? Text('No image selected.') : Container(
                height: 400,
                width: 400,
                child: Image.file(_image!)))
            :Container(
                height: 200,
                width: 200,
                child: Image.network(imageURL!)),
            SizedBox(height: 20.h,),
            ElevatedButton(
              onPressed: (){
                getImage();
              },
              child: Text('Pick Image'),
            ),
      _image == null ? Container() : ElevatedButton(
        onPressed: (){

          uploadFile(name:widget.name);
        },
        child: Text('Upload Picture'),
      ),


            // ElevatedButton(
            //   onPressed: _updateUserDetails,
            //   child: Text("Update Details"),
            // ),
          ],
        ),
      ),
    );
  }
}
