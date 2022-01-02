import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mesajdeneme/home_client/home.dart';
import 'package:mesajdeneme/screens/profile_page.dart';
import 'package:mesajdeneme/utils/fire_auth.dart';
import 'package:mesajdeneme/utils/validator.dart';

class Rename extends StatefulWidget {
  @override
  _RenameState createState() => _RenameState();
}

class _RenameState extends State<Rename> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();

  final _focusName = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(user: user),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adı Güncelleme'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'Yeni Ad',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameTextController,
                            focusNode: _focusName,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Yeni Adınız:",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          _isProcessing
                              ? CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          _focusName.unfocus();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _isProcessing = true;
                                            });
                                            FirebaseAuth auth =
                                                FirebaseAuth.instance;
                                            User? user = auth.currentUser;
                                            await user!.updateDisplayName(
                                                _nameTextController.text);
                                            await FireAuth.profileKaydet(user);
                                            setState(() {
                                              _isProcessing = false;
                                            });
                                            User? newuser =
                                                await FireAuth.refreshUser(
                                                    user);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                          user: newuser)),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Kaydet',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
