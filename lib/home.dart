import 'package:flutter/material.dart';

import 'main.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          '메인 홈입니다.'
          ,style: TextStyle(
            fontSize :30,
            color : Colors.black,
          ),
        ),
      ),
      drawer: SideDrawer(),
      backgroundColor: const Color(0xffece6cc),
    );
  }
}