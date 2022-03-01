import 'package:flutter/material.dart';

class CentreScreenLayout extends StatelessWidget {
  final Widget child;
  const CentreScreenLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: child,
      ),
    );
  }
}
