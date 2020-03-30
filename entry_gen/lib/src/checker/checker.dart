import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

class AnnotationChecker {
  static bool isJsonSerializable(Element element) {
    const checker = TypeChecker.fromRuntime(JsonSerializable);
    return checker.hasAnnotationOfExact(element);
  }
}

class Checker {
  static bool isHttpResponse(Element element) {
    const checker = TypeChecker.fromRuntime(http.Response);
    return checker.isExactly(element);
  }

  static bool isString(Element element) {
    const checker = TypeChecker.fromRuntime(String);
    return checker.isExactly(element);
  }
}
