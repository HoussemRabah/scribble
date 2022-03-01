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
