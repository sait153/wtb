import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mesajdeneme/home_client/home.dart';
import 'package:mesajdeneme/screens/login_page.dart';
import 'package:mesajdeneme/screens/profile_page.dart';
import 'package:mesajdeneme/utils/fire_auth.dart';

class Drawer1 extends StatefulWidget {
  const Drawer1({Key? key}) : super(key: key);

  @override
  _Drawer1State createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  bool _darkModeState = false;
  late User? _currentUser;
  late bool loading;
  @override
  void initState() {
    setState(() {
      loading = true;
    });
    _currentUser = null;
    _initializeFirebase();

    super.initState();
  }

  _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    print(user!.photoURL);
    if (user != null) {
      setState(() {
        _currentUser = user;
        loading = false;
      });
    }
  }

  void _goProfile() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ProfilePage(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.86,
        margin: EdgeInsets.only(left: 6, top: 30, bottom: 10),
        padding: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Stack(children: [
          if (_currentUser != null) ...[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 250.0,
                  flexibleSpace: Stack(
                    children: [
                      Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (_currentUser?.photoURL != null) ...[
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
                          if (_currentUser!.photoURL == null) ...[
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
                          ]
                        ],
                      )),
                    ],
                  ),
                ),

                //Replace with Image From DB
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Text(
                          _currentUser!.displayName.toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 6, left: 45, right: 45),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.9,
                                style: BorderStyle.none),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                //leading: Icon(Icons.home),
                                title: Text(
                                  'Anasayfa',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Icon(
                                  Icons.home,
                                  //size: 30,
                                ),
                                onTap: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Home(user: _currentUser)))
                                },
                              ),
                              Divider(
                                height: 0,
                                indent: 15,
                                endIndent: 15,
                              ),
                              ListTile(
                                //leading: Text(''),
                                title: Text(
                                  'Profilim',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Icon(
                                  Icons.account_box,
                                  // size: 30,
                                ),
                                onTap: () => _goProfile(),
                              ),
                              Divider(
                                height: 0,
                                indent: 15,
                                endIndent: 15,
                              ),
                              ListTile(
                                //leading: Text(''),
                                title: Text(
                                  'Çıkış',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Icon(
                                  Icons.exit_to_app,
                                ),
                                onTap: () async {
                                  await FireAuth.mesaiKaydet(
                                      _currentUser, 'bitis');
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                              ),
                              Divider(
                                height: 0,
                                indent: 15,
                                endIndent: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FractionalTranslation(
              translation: Offset(0.0, 0.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Material(
                    elevation: 10.0,
                    type: MaterialType.circle,
                    color: Colors.white,
                    child: Icon(
                      //Icons.arrow_back,
                      Icons.close,
                      color: Colors.black45,
                      size: 35.0,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ]),
      ),
    );
  }
}
