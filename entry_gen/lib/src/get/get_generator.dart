import 'package:analyzer/dart/element/element.dart';

import 'get_annotaion.dart';

class GetGenerator {
  final String base;
  final ClassElement classElement;
  const GetGenerator(this.base, this.classElement);

  List<GetAnnotation> get _list {
    final List<GetAnnotation> list = this.classElement.fields.map( (field) {
      return GetAnnotation(this.base, field);
    }).toList();
    list.removeWhere((annotation) => !annotation.isGet);
    return list;
  }

  List<String> get _genedString {
    return _list.map( (getAnnotation) =>  getAnnotation.gen).toList();
  }

  /// Get Annotation Count
  int get count => _list.length;

  /// the code string, gen by you.
  String get gen => _genedString.join("\n\n");
}