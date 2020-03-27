import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:entry/entry.dart';

import 'get/get_generator.dart';

class EntryGenerator extends GeneratorForAnnotation<Base> {
  
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the Entry2 annotation from `$name`.',
          element: element);
    }

    final ClassElement classElement = element as ClassElement;

    final className = classElement.displayName;
    final base = annotation.read("base").stringValue;

    final getGenerator = GetGenerator(base, classElement);

    return '''
/// Get Method: ${getGenerator.count}
class Gen${className} {
  ${getGenerator.gen}
}
    ''';
  }
}
