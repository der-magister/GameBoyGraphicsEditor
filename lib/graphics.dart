class GraphicElement {
  String name;
  String values;

  GraphicElement({required this.name, required this.values});
}

abstract class Graphics {
  int height;
  int width;
  String name;

  Graphics({required this.name, required this.width, required this.height});

  bool fromSource(String source);

  String toHeader();

  String toSource();

  String formatOutput(input) {
    return input.asMap().entries.map((entry) {
      int idx = entry.key;
      String val = entry.value;
      return idx % 8 == 0 ? "\n  $val" : val;
    }).join(", ");
  }

  List<GraphicElement> fromGBDKSource(source) {
    var arrayElements = <GraphicElement>[];

    RegExp regExp = RegExp(r"unsigned\s+char\s+(\w+)\[\]\s*=\s*\{(.*?)};");
    for (Match match in regExp.allMatches(source)) {
      arrayElements
          .add(GraphicElement(name: match.group(1)!, values: match.group(2)!));
    }

    return arrayElements;
  }
}
