import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    // Get the user's profile picture from Firebase Storage if it exists
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference =
          storage.ref().child('user-profiles/${user.uid}/profile.jpg');
      reference.getDownloadURL().then((url) {
        setState(() {
          _imageUrl = url;
        });
      }).catchError((error) {
        // The profile picture doesn't exist in Firebase Storage
        print(error);
      });
    }
  }

  Future pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      uploadImageToFirebase();
    }
  }

  Future uploadImageToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      print('User not signed in.');
      return;
    }
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref().child('user-profiles/${user.uid}/profile.jpg');
    UploadTask uploadTask = reference.putFile(_image!);
    await uploadTask.whenComplete(() {
      print('Image uploaded to Firebase.');
      // Get the URL of the uploaded image and update the state
      reference.getDownloadURL().then((url) {
        setState(() {
          _imageUrl = url;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: _imageUrl != null
                ? NetworkImage(_imageUrl!)
                : _image != null
                    ? FileImage(_image!) as ImageProvider<Object>?
                    : AssetImage("assets/images/Profile Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  pickImage();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
