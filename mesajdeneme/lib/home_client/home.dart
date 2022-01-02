import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:mesaj/drawer/drawer.dart';
//import 'package:mesaj/home_client/rehber.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:mesaj/home_client/mesajlar.dart';
//import 'package:mesaj/screens/profile_page.dart';
//import 'package:mesaj/utils/fire_auth.dart';

class Home extends StatefulWidget {
  final User? user;

  Home({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User? _currentUser;

  @override
  void initState() {
    setState(() {
      _currentUser = widget.user;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          //drawer: const Drawer1(),
          // extendBody: true,
          drawerDragStartBehavior: DragStartBehavior.start,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              controller: _tabController,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(
                  // icon: Icon(Icons.directions_car,),
                  child: Text(
                    'Sohbetler',
                  ),
                ),
                Tab(
                  //icon: Icon(Icons.directions_transit),
                  child: Text('Rehber'),
                ),
              ],
            ),
            title: Text(
              _currentUser!.displayName.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              //Mesajlar(user:_currentUser),
              //const Rehber(),
            ],
          )),
    );
  }
}
