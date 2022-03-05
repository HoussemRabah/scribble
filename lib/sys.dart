import 'dart:math';

String getDefaultName() {
  List<String> names = [
    "Mc Loser",
    "farcha",
    "naruto",
    "bella ciao",
    "mahrez",
    "liverpool",
    "chikor",
    "tabon",
    "midoriya",
    "jojo",
    "levi",
    "tjib bac tthna",
    "ISIL tbhdl",
    "UML2.0 is useless",
    "LOL"
  ];
  int random = Random().nextInt(names.length);

  return names[random];
}

List<String> getGeneratedWords() {
  List<String> names = [
    "Car",
    "phone",
    "pc",
    "girl",
    "monster",
    "space",
    "star",
    "dommino",
    "chess",
    "time",
    "messi",
    "microclub",
    "fire",
    "cat",
    "rocket"
  ];
  int random1 = Random().nextInt(names.length);
  int random2 = Random().nextInt(names.length);
  int random3 = Random().nextInt(names.length);

  return [names[random1], names[random2], names[random3]];
}
