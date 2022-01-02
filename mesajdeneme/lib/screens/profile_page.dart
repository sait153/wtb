import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mesajdeneme/home_client/home.dart';
import 'package:mesajdeneme/screens/rename.dart';
import 'package:mesajdeneme/utils/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User? user;

  // ignore: use_key_in_widget_constructors
  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late XFile? imageFile;

  late User? _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    setState(() {
      imageFile = null;
    });
    super.initState();
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }

    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  // Pick an image

  // Capture a photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.home,
            size: 20.0,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Home(user: _currentUser),
              ),
            );
          },
        ),
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (_currentUser != null) ...[
                          if (imageFile == null &&
                              _currentUser?.photoURL != null) ...[
                            CachedNetworkImage(
                              imageUrl: _currentUser!.photoURL.toString(),
                              height: 200,
                              width: 200,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.red, BlendMode.colorBurn)),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ],
                          if (imageFile == null &&
                              _currentUser!.photoURL == null) ...[
                            Container(
                              width: 190.0,
                              height: 190.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/img/user.png"),
                                ),
                              ),
                            ),
                          ],

                          // ignore: unnecessary_null_comparison
                          if (imageFile != null) ...[
                            SizedBox(
                              width: 190.0,
                              height: 190.0,
                              child: CircleAvatar(
                                backgroundImage:
                                    FileImage(File(imageFile!.path)),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;
                                String? photoURL = await FireAuth.uploadFile(
                                    _currentUser!.uid,
                                    'img',
                                    'profile',
                                    'profilePhoto',
                                    imageFile!);
                                await _currentUser!.updatePhotoURL(photoURL);
                                User? _ruser =
                                    await FireAuth.refreshUser(widget.user);
                                await FireAuth.profileKaydet(_ruser);
                                setState(() {
                                  _currentUser = _ruser;
                                });
                              },
                              child: Text('Resmi Kaydet'),
                            ),
                          ],
                          IconButton(
                            iconSize: 34.0,
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                            icon: Icon(Icons.camera_alt_outlined),
                          ),

                          TextFormField(
                            readOnly: true,
                            initialValue: _currentUser?.displayName,
                            decoration: InputDecoration(
                              hintText: "Adınız",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue: _currentUser?.email,
                            decoration: InputDecoration(
                              hintText: "Adınız",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ]),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Rename(),
                    ),
                  );
                },
                child: Text('Adınızı Güncelleyin'),
              ),
              SizedBox(width: 8.0),
              SizedBox(height: 16.0),
              _currentUser!.emailVerified
                  ? Text(
                      'Email doğrulanmış',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.green),
                    )
                  : Text(
                      'Email doğrulanmamış',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red),
                    ),
              SizedBox(height: 16.0),
              _isSendingVerification
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isSendingVerification = true;
                            });
                            await _currentUser?.sendEmailVerification();
                            setState(() {
                              _isSendingVerification = false;
                            });
                          },
                          child: Text('Email Doğrula'),
                        ),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            User? user =
                                await FireAuth.refreshUser(_currentUser);

                            if (user != null) {
                              setState(() {
                                _currentUser = user;
                              });
                            }
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
