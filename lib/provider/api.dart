import 'dart:convert';
import 'dart:async';
import 'package:funny_video/model/Album.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbum() async {
  List<Album> list = [];
  final response = await http
      .get('https://www.pinkvilla.com/feed/video-test/video-feed.json');

  var res = json.decode(response.body);
  return (res as List).map((p) => Album.fromJson(p)).toList();
  // map.forEach((key, value) {
  //   print("key" + key);
  //   print("value" + value);
  //   list.add(value);
  // });
  // print("list" + list.toString());
  // return list;
  // return Album.fromJson(json.decode(response.body));
}
