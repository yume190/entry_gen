library entry.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/gen.dart';

/// generate to x.g.dart
Builder entryBuilder(BuilderOptions options) =>
  SharedPartBuilder([EntryGenerator()], 'entry');
  