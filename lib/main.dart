import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:cp949/cp949.dart' as cp949;

class Counter extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  Future fetch() async {
    // var movieURL = 'https://www.ypbooks.co.kr/m_bestseller.yp';
    // var movieURL = 'https://movie.naver.com/movie/running/current.nhn';
    var movieURL = 'https://www.kyobobook.co.kr/bestSellerNew/bestseller.laf';

    http.Response response = await http.get(Uri.parse(movieURL));
    // dom.Document document = parser.parse(response.body);
    dom.Document document = parser.parse(cp949.decodeString(response.body));
    // var keywordElements = document.querySelectorAll('.l-container .tab-content li');
      // var keywordElements = document.querySelectorAll('.lst_wrap .lst_detail_t1 li');
    var keywordElements = document.querySelectorAll('#main_contents .list_type01 li .cover');
  
    List<Map<String, dynamic>> keywords = [];
    for(var i in keywordElements) {
      var k = i;
      var url = k.children[0].attributes['href'];
      var img = k.querySelector('img')!.attributes['src'].toString().split('?')[0];
      var name = k.querySelector('img')!.attributes['alt'];
      
      keywords.add({
        'url': url,
        'thumb': img,
        'title': name,
      });
    }

    print(keywords);

    return keywords;
  }
  void _increment() {
    fetch();
    
    setState(() {
      // This call to setState tells the Flutter framework
      // that something has changed in this State, which
      // causes it to rerun the build method below so that
      // the display can reflect the updated values. If you
      // change _counter without calling setState(), then
      // the build method won't be called again, and so
      // nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    // for instance, as done by the _increment method above.
    // The Flutter framework has been optimized to make
    // rerunning build methods fast, so that you can just
    // rebuild anything that needs updating rather than
    // having to individually changes instances of widgets.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
        const SizedBox(width: 16),
        Text('Count: $_counter'),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}