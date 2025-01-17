import 'package:game_boy_graphics_editor/models/graphics/background.dart';
import 'package:game_boy_graphics_editor/models/sourceConverters/source_converter.dart';

import '../graphics/graphics.dart';

class GBDKBackgroundConverter extends SourceConverter {
  static final GBDKBackgroundConverter _singleton = GBDKBackgroundConverter._internal();

  factory GBDKBackgroundConverter() {
    return _singleton;
  }

  GBDKBackgroundConverter._internal();

  @override
  String toHeader(Graphics graphics, String name) => """/*
Info: 
  Tile set  : $name    
*/
#define ${name}Width ${graphics.width}
#define ${name}Height ${graphics.height}
#define ${name}Bank 0
extern unsigned char $name[];""";

  @override
  String toSource(Graphics graphics, String name) => """#define ${name}Width ${graphics.width}
#define ${name}Height ${graphics.height}
#define ${name}Bank 0
unsigned char $name[] = {${formatOutput(graphics.data.map((e) => decimalToHex(e)).toList())}};""";

  List fromSource(String source) {
    var background = Background();

    var graphicElement = readGraphicElementsFromSource(source)[0];
    background.data =
        List<int>.from(graphicElement.values.split(',').map((value) => int.parse(value)).toList());

    RegExp regExpWidth = RegExp(r"#define \w+Width (\d+)");
    var matchesWidth = regExpWidth.allMatches(source);
    for (Match match in matchesWidth) {
      background.width = int.parse(match.group(1)!);
    }

    RegExp regExpHeight = RegExp(r"#define \w+Height (\d+)");
    var matchesHeight = regExpHeight.allMatches(source);
    for (Match match in matchesHeight) {
      background.height = int.parse(match.group(1)!);
    }
    return [graphicElement.name, background];
  }
}
