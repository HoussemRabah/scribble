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
            children: [
              SvgPicture.asset("assets/Boy.svg",
                  width: 41, fit: BoxFit.fitWidth),
              SvgPicture.asset("assets/The rock.svg",
                  width: 59, fit: BoxFit.fitWidth),
              SvgPicture.asset("assets/Girl.svg",
                  width: 41, fit: BoxFit.fitWidth),
            ],
          ),
          Text(userBloc.storage.username ?? "ops null error ):",
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
