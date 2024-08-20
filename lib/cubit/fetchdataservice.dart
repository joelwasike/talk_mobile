import 'package:hive_flutter/adapters.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Dataservice {
  //getpostshomepage
  Future<List<dynamic>> fetchData() async {
    final url = Uri.parse('$baseUrl/getposts');
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("posts", jsonData);
    return jsonData;
  }

  //getnoticeposts
  Future<List<dynamic>> fetchNotices() async {
    final url = Uri.parse('$baseUrl/getnotices');
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("notices", jsonData);
    return jsonData;
  }

  //getgossips
  Future<List<dynamic>> fetchGossip() async {
    final url = Uri.parse('$baseUrl/getgossips'); // Replace with your JSON URL
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("gossips", jsonData);
    return jsonData;
  }

  //forumlist
  Future<List<dynamic>> fetchforumlist() async {
    final url = Uri.parse('$baseUrl/getforums');
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("forumlist", jsonData);
    return jsonData;
  }

  //clublist
  Future<List<dynamic>> fetchClubList() async {
    final url = Uri.parse('$baseUrl/getclubs'); // Replace with your JSON URL
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("clublist", jsonData);
    return jsonData;
  }

  //get forum posts
  Future<List<dynamic>> fetchforumposts(id) async {
    final url =
        Uri.parse('$baseUrl/getforumposts/$id'); // Replace with your JSON URL
    final response = await http.get(url);
    final List<dynamic> jsonData = json.decode(response.body);
    var box = Hive.box("Talk");
    box.put("forumposts$id", jsonData);
    return jsonData;
  }
}
