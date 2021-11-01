import 'package:flutter/material.dart';
import 'book-detail.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:cp949/cp949.dart' as cp949;

class BookList extends StatefulWidget {
  BookList({
    Key? key,
  }) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
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

    return keywords;
  }
  
  @override
  Widget build(BuildContext context) {
  
    // ignore: unnecessary_new
    return new MaterialApp(
      // 구글 기본 디자인인 Material Design을 써서 앱을 만든다.
      home: Scaffold(
        appBar: AppBar(
          title: Text('Best 20'),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(  //FutureBuilder 를 사용하여 데이터 가져오기
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return bodyWidget(snapshot.data as List<Map<String, dynamic>>);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        drawer: SideDrawer(),
        backgroundColor: const Color(0xffece6cc),
      )
    );
  }
}

Widget bodyWidget(List<Map<String, dynamic>> bookList) {
  
  return Container(
    child: ListView.separated( // listview
      // controller: _scrollController,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.grey,
        height: 4,
      ), //separatorBuilder : item과 item 사이에 그려질 위젯 (개수는 itemCount -1 이 된다)
    // child: PageView.builder( // pageview
      itemCount: bookList.length, //리스트의 개수
      itemBuilder: (BuildContext context, int index) {
        int row = index+1;
        //리스트의 반목문 항목 형성
        return Container(
          height: 80,
          decoration: BoxDecoration(
            // color: Colors.pink[index * 100],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$row',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Image.network(
                bookList[index]['thumb'],
              ),
              Expanded(
                child : GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      bookList[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetail(url : bookList[index]['url'])
                      ),
                    )
                  }
                )
              ),
            ],
          ),
        );
      },
    ),
  );
}

