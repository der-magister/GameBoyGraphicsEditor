import 'dart:convert';

import '../graphics/graphics.dart';

String toBinary(String value) {
  return int.parse(value).toRadixString(2).padLeft(8, "0");
}

String binaryToHex(value) {
  return "0x${int.parse(value, radix: 2).toRadixString(16).padLeft(2, "0").toUpperCase()}";
}

String decimalToHex(int value) {
  return "0x${value.toRadixString(16).padLeft(2, "0").toUpperCase()}";
}

class GraphicElement {
  String name;
  String values;

  GraphicElement({required this.name, required this.values});
}

abstract class SourceConverter {
  String formatOutput(input) {
    return input.asMap().entries.map((entry) {
      int idx = entry.key;
      String val = entry.value;
      return idx % 8 == 0 ? "\n  $val" : val;
    }).join(", ");
  }

  String toHeader(Graphics graphics, String name);

  String toSource(Graphics graphics, String name);

  String formatSource(String source) {
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(source);
    return lines.join();
  }

  List<GraphicElement> readGraphicElementsFromSource(String source) {
    var arrayElements = <GraphicElement>[];

    RegExp regExp =
    RegExp(r"(?:unsigned\s+char|uint8_t|UINT8)\s+(\w+)\[(?:\d+)?\]\s*=\s*\{(.*?)};");
    for (Match match in regExp.allMatches(source)) {
      arrayElements.add(GraphicElement(name: match.group(1)!, values: match.group(2)!));
    }

    return arrayElements;
  }
}
