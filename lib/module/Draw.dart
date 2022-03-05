import 'package:flutter/cupertino.dart';

class Draw {
  List<List<Offset>> points;
  List<Color> colors;
  Draw({required this.points, required this.colors});

  addDraw(List<Offset> newPoints, Color newColor) {
    points.add(newPoints);
    colors.add(newColor);
  }

  updateDraw(Offset newPoint) {
    points.last.add(newPoint);
  }

  undoDraw() {
    if (points.isNotEmpty) points.removeLast();
  }

  removeDraw() {
    points = [];
  }

  String toText() {
    String data = "";
    for (List<Offset> pack in points) {
      for (Offset point in pack) {
        data += point.dx.toString() + "," + point.dy.toString() + ";";
      }
      data += "/";
    }
    data += "+";
    for (Color color in colors) {
      data += color.alpha.toString() +
          ";" +
          color.red.toString() +
          ";" +
          color.green.toString() +
          ";" +
          color.blue.toString() +
          ',';
    }
    return data;
  }

  Draw fromText(String data) {
    String pointsText = "";
    String colorsText = "";
    if (data.isNotEmpty) {
      colors = [];
      points = [];
      pointsText = data.split("+")[0];
      colorsText = data.split("+")[1];
    }
    if (pointsText != "" && colorsText != "") {
      points = [];
      colors = [];
      List<String> packsText = pointsText.split("/");
      for (String packText in packsText) {
        List<String> offsetsText = packText.split(";");
        List<Offset> pack = [];

        for (String offsetText in offsetsText) {
          if (offsetText != "") {
            String x = offsetText.split(",")[0];
            String y = offsetText.split(",")[1];
            if (double.tryParse(x) != null && double.tryParse(y) != null)
              pack.add(Offset(double.parse(x), double.parse(y)));
          }
        }
        points.add(pack);
      }
      List<String> colorsPackText = colorsText.split(",");
      for (String color in colorsPackText) {
        if (color != "")
          colors.add(Color.fromARGB(
              int.parse(color.split(";")[0]),
              int.parse(color.split(";")[1]),
              int.parse(color.split(";")[2]),
              int.parse(color.split(";")[3])));
      }
    }

    return this;
  }

  toMap() => {"draw": toText()};
}
