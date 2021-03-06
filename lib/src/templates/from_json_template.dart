import 'package:analyzer/dart/element/element.dart';
import 'package:freezed/src/templates/parameter_template.dart';
import 'package:freezed/src/templates/prototypes.dart';
import 'package:meta/meta.dart';

class FromJson {
  FromJson({
    @required this.name,
    @required this.constructors,
    @required this.typeParameters,
  });

  final String name;
  final List<ConstructorElement> constructors;
  final List<TypeParameterElement> typeParameters;

  @override
  String toString() {
    final cases = constructors.map((constructor) {
      final caseName = isDefaultConstructor(constructor) ? 'default' : constructor.name;
      final concreteName = getRedirectedConstructorName(constructor);

      return '''
case '$caseName':
  return $concreteName${GenericsParameterTemplate(typeParameters)}.fromJson(json);
''';
    }).join();

    return '''
$name${GenericsParameterTemplate(typeParameters)} _\$${name}FromJson${GenericsDefinitionTemplate(typeParameters)}(Map<String, dynamic> json) {
  assert(json['runtimeType'] is String);
  switch (json['runtimeType'] as String) {
    $cases
    default:
      throw FallThroughError();
  }
}
''';
  }
}
