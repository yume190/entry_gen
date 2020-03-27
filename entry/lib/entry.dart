library entry;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

enum RequestMethod { get, post }

class Base {
  final String base;
  const Base({@required this.base});
}

/// http.get(url, {Map<String, String> headers})
class Get {
  final String path;
  const Get({@required this.path});
}

/// http.post(url, {Map<String, String> headers, body, Encoding encoding})
class Post {
  final String path;

  final Map<String, String> headers;
  final dynamic body;
  final Encoding encoding;

  const Post({@required this.path, this.headers, this.body, this.encoding});
}

typedef Future<http.Response> Request();

class Entry {
  final Request request;
  const Entry({@required this.request});

  Future<http.Response> get response async {
    return await this.request();
  }

  Future<String> get body async {
    final res = await this.response;
    return res.body;
  }

  Future<Map<String, dynamic>> get bodyMap async {
    final body = await this.body;
    return json.decode(body);
  }
}
