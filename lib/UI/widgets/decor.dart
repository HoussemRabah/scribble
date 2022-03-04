import 'package:flutter/material.dart';

class Cadre extends StatefulWidget {
  final Widget child;
  const Cadre({Key? key, required this.child}) : super(key: key);

  @override
  State<Cadre> createState() => _CadreState();
}

class _CadreState extends State<Cadre> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(2.5),
      child: widget.child,
    );
  }
}
