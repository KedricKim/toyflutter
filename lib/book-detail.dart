import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:cp949/cp949.dart' as cp949;

import 'main.dart';

class BookDetail extends StatelessWidget {

  final String url;

  BookDetail({
    Key? key, required this.url,
  }) : super(key: key);

  Future fetch() async {
    var movieURL = url;

    http.Response response = await http.get(Uri.parse(movieURL));
    dom.Document document = parser.parse(cp949.decodeString(response.body));
    var imgElement = document.querySelector('.box_detail_cover .cover');
    var detailElement = document.querySelector('.box_detail_point');
  
    Map<String, dynamic> keywords = {};
    var img = imgElement!.querySelector('img')!.attributes['src'].toString().split('?')[0];
    var name = detailElement!.querySelector('.title strong')!.innerHtml;
    var author = detailElement!.querySelectorAll('.author .name a');
    var publisher = author[author.length-1].text;

    var authurName = "";
    for(int i=0;i<author.length-1;i++) {
      authurName += author[i].text;
      if(i+2 != author.length) authurName += ", ";
    }

    keywords["thumb"] = img;
    keywords["name"] = name;
    keywords["authurName"] = authurName;
    keywords["publisher"] = publisher;

    print(keywords);
    
    return keywords;
  }

  @override
  Widget build(BuildContext context) {
  
    return new MaterialApp(
      home : Scaffold(
        appBar: AppBar(
          title: Text('Book Detail'),
          backgroundColor: Colors.black,
        ),
        body: 
          FutureBuilder(  //FutureBuilder 를 사용하여 데이터 가져오기
            future: fetch(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return bodyWidget(snapshot.data as Map<String, dynamic>);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        drawer: SideDrawer(),
      )
    );
  }
}

Widget bodyWidget(Map<String, dynamic> bookDetail) {
  
  return Container(
    child: 
    // Text('asd')
    Scaffold(
      body: SingleChildScrollView(
        child: Column(  //Row , Column
          children: [ 
            Padding(
              padding: EdgeInsets.only(top:50),
              child: Image.network(
                bookDetail["thumb"],
              ),
            ),
            Text(
              bookDetail["name"], 
              style: TextStyle(
                fontSize :20,
                color : Colors.black,
              )
            ), 
            Text(bookDetail["authurName"] + " 지음"),
            Text("출판사 : " + bookDetail["publisher"]), 
          ],
        ),
      ),
      backgroundColor: const Color(0xffece6cc),
    )
  );
}