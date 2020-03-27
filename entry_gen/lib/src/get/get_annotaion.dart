import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:entry/entry.dart';

final _getKeyExpando = Expando<Get>();
const _getChecker = TypeChecker.fromRuntime(Get);

class GetAnnotation {
  final String base;
  final FieldElement field;
  const GetAnnotation(this.base, this.field);

  bool get isGet {
    return this._path != null;
  }

  String get _path {
    return _getKeyExpando[this.field]?.path ?? _getChecker.firstAnnotationOfExact(this.field).getField("path")?.toStringValue();
  }

  String get _fieldName => field.name;
  String get _responseType => '${field.type}';

  String get gen {
    return '''
  static Future<${this._responseType}> ${this._fieldName}(Map<String, dynamic> queryParameters, Map<String, String> headers) async {
    final base = '${this.base}';
    final path = '${_path}';
    final uri = Uri.parse('\$base/\$path').replace(queryParameters: queryParameters);

    final entry = Entry(request: () async {
      return await http.get(uri, headers: headers);
    });

    final map = await entry.bodyMap;
    return ${this._responseType}.fromJson(map);
  }
    ''';
  }
}