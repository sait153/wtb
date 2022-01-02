import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FireAuth {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
      await profileKaydet(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await profileKaydet(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User? user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user?.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<User?> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    return user;
  }

  static Future<bool> mesaiKaydet(User? user, String turu) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("mesai")
        .doc(user?.uid)
        .collection(turu)
        .doc(formattedDate)
        .set({
          'adi': user!.displayName, // John Doe
          'profilUrl': user.photoURL,
          'girisZamani': FieldValue.serverTimestamp() // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return true;
  }

  static Future<bool> profileKaydet(User? user) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(user?.uid)
        .collection("profile")
        .doc("profile")
        .set({
          'adi': user!.displayName, // John Doe
          'profilUrl': user.photoURL,
          'girisZamani': FieldValue.serverTimestamp() // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return true;
  }

  static Future<bool> mesaiGetir(User? user, String turu) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("mesai")
        .doc(user?.uid)
        .collection(turu)
        .doc(formattedDate)
        .set({
          'adi': user!.displayName, // John Doe
          'profilUrl': user.photoURL,
          'girisZamani': FieldValue.serverTimestamp() // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return true;
  }

  static Future<String> uploadFile(String userID, String folder,
      String childFolder, String fileName, XFile file) async {
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(userID)
        .child(folder)
        .child(childFolder)
        .child(fileName);
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    uploadTask = ref.putFile(io.File(file.path), metadata);
  
   
    var url = await ref.getDownloadURL();
    return url;
  }
}
