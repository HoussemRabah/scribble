import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/pages/home.dart';

import '../../constants.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({Key? key}) : super(key: key);

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBack,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/Skins/Boy.svg",
                width: 41,
                fit: BoxFit.fitWidth,
              ),
              SvgPicture.asset("assets/Skins/The rock.svg",
                  width: 59, fit: BoxFit.fitWidth),
              SvgPicture.asset("assets/Skins/Girl.svg",
                  width: 41, fit: BoxFit.fitWidth),
            ],
          ),
          Text(userBloc.userName ?? "ops null error ):",
              style: textStyleBig.copyWith(
                color: Colors.white,
              )),
          //    Button(), X2
          Row(
            children: [
              // ButtonSqaure()
              // ButtonRound()
              // ButtonSqaure()
            ],
          ),
          Row(
            children: [
              //LeftArrow()
              //RightArrow()
            ],
          )
        ],
      ),
    );
  }
}
