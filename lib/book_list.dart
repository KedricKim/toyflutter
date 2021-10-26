import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:english_words/english_words.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList>{
  Future fetch() async {
    var movieURL = ['https://movie.naver.com/movie/running/current.nhn', 'https://movie.naver.com/movie/running/premovie.nhn?order=reserve'];
    List<List<Map<String, dynamic>>> list = [];
    for(var URL in movieURL){
      http.Response response = await http.get(Uri.parse(URL));
      dom.Document document = parser.parse(response.body);
      var keywordElements = document.querySelectorAll('.lst_wrap .lst_detail_t1 li');

      List<Map<String, dynamic>> keywords = [];
      for(var i in keywordElements) {
        var url = i.querySelector('a')!.attributes['href'];
        var img = i.querySelector('img')!.attributes['src'].toString().split('?')[0];
        var name = i.querySelector('img')!.attributes['alt'];
        keywords.add({
          'url': url,
          'thumb': img,
          'title': name
        });
      }
      list.add(keywords);
    }

    return list;
  }

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Startup Name Generator'),
    ),
    body: _buildSuggestions(),
  );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}