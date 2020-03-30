import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:entry_gen/src/checker/checker.dart';
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
  String get _uri => '${this.base}/${this._path}';

  String get description => ' * ${this._fieldName}: ${this._uri}';

  Iterable<DartType> getGenericTypes(DartType type) {
    return type is ParameterizedType ? type.typeArguments : const [];
  }
  String get _getReturn {
    final element = this.field.type.element;
    if (AnnotationChecker.isJsonSerializable(element)) {
      return '''
      final map = await entry.bodyMap;
      return ${this._responseType}.fromJson(map);
      ''';
    }

    if (Checker.isHttpResponse(element)) {
      return '''
      return await entry.response;
      ''';
    }

    if (Checker.isString(element)) {
      return '''
      return await entry.body;
      ''';
    }

    final name = 'yume';
    throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the Get annotation from `$name`.',
          element: element);
  }

  String get gen {
    return '''
  static Future<${this._responseType}> ${this._fieldName}(Map<String, dynamic> queryParameters, Map<String, String> headers) async {
    final uri = Uri.parse('${this._uri}').replace(queryParameters: queryParameters);

    final entry = Entry(request: () async {
      return await get(uri, headers: headers);
    });

    ${this._getReturn}
  }
    ''';
  }
}

// Future<http.Response> get response async {
//     return await this.request();
//   }

//   Future<String> get body async {
//     final res = await this.response;
//     return res.body;
//   }

//   Future<Map<String, dynamic>> get bodyMap async {
//     final body = await this.body;
//     return json.decode(body);
//   }