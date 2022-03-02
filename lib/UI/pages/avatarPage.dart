import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/bloc/userBloc/user_bloc.dart';

import '../../constants.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({Key? key}) : super(key: key);

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

List<String> avatars = [
  "assets/Skins/Girl.svg",
  "assets/Skins/Boy.svg",
  "assets/Skins/The rock.svg"
];

class _AvatarPageState extends State<AvatarPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: userBloc)],
      child: Scaffold(
        backgroundColor: colorBack,
        body: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return AvtarSelctor();
              },
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
      ),
    );
  }
}

class AvtarSelctor extends StatelessWidget {
  const AvtarSelctor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            context.read<UserBloc>().add(UserEventChangeAvatar(
                newAvatar: avatars[1])); // just to rebuild widget
            refreshAvtars(0);
          },
          child: SvgPicture.asset(
            avatars[0],
            width: 41,
            fit: BoxFit.fitWidth,
            theme: SvgTheme(currentColor: Colors.white),
          ),
        ),
        SvgPicture.asset(avatars[1],
            width: 59,
            fit: BoxFit.fitWidth,
            theme: SvgTheme(currentColor: Colors.white)),
        GestureDetector(
          onTap: () {
            context.read<UserBloc>().add(UserEventChangeAvatar(
                newAvatar: avatars[1])); // just to rebuild widget
            refreshAvtars(2);
          },
          child: SvgPicture.asset(avatars[2],
              width: 41,
              fit: BoxFit.fitWidth,
              theme: SvgTheme(currentColor: Colors.white)),
        ),
      ],
    );
  }
}

refreshAvtars(int index) {
  String temp = avatars[1];
  avatars[1] = avatars[index];
  avatars[index] = temp;
}
