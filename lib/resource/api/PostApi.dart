
import 'dart:convert';

import 'package:flutterlibbloc/model/post.dart';
import 'package:http/http.dart' as Client;

class PostApi {

  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPost(int startIndex, int limit) async {
    final String url = "$baseUrl/posts?_start=$startIndex&_limit=$limit";
    final response = await Client.get(url);
    if (response.statusCode == 200) {
      print('response.statusCode = ${response.statusCode}');
      print('response.body = ${response.body}');
      final data = json.decode(response.body) as List;
      return data.map((rawData){
        return Post(id: rawData['id'], title: rawData['title'], body: rawData['body']);
      }).toList();
    } else {
      throw Exception("Load Failed");
    }
  }

}