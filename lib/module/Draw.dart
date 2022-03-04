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
    points.removeLast();
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

  fromText(String data) {
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
          pack.add(Offset(double.parse(offsetText.split(",")[0]),
              double.parse(offsetText.split(",")[1])));
        }
        points.add(pack);
      }
      List<String> colorsPackText = colorsText.split(",");
      for (String color in colorsPackText) {
        colors.add(Color.fromARGB(
            int.parse(color.split(";")[0]),
            int.parse(color.split(";")[1]),
            int.parse(color.split(";")[2]),
            int.parse(color.split(";")[3])));
      }
    }
  }

  toMap() => {"draw": toText()};
}
