import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/UI/widgets/laoding.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/bloc/userBloc/user_bloc.dart';
import 'package:scribble/module/player.dart';

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
      providers: [
        BlocProvider.value(value: userBloc),
        BlocProvider.value(value: roomBloc),
      ],
      child: Scaffold(
        backgroundColor: colorBack,
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state is RoomInitial) return InitialView();
            if (state is RoomStateNewRoom)
              return NewRoomView(
                state: state,
              );
            if (state is RoomStateJoinRoom)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onSubmitted: (code) {
                      roomBloc..add(RoomEventJoinRoomStart(roomId: code));
                    },
                    style: textStyleBig,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "ROOM CODE"),
                  ),
                  Text(
                    roomBloc.error,
                    style: textStyleError,
                  ),
                ],
              );
            if (state is RoomStateLoading)
              return Center(
                child: LoadingBar(process: state.process),
              );
            return Text("ops ! ");
          },
        ),
      ),
    );
  }
}

class NewRoomView extends StatelessWidget {
  final RoomStateNewRoom state;
  const NewRoomView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText(
          "ROOM ID : ${state.id}",
          style: textStyleBig,
          textAlign: TextAlign.center,
        ),
        // players
        PlayersInRoom(state: state),

        // play
        Button(text: roomBloc.iamTheCreator ? "play" : "exit", function: () {})
      ],
    );
  }
}

class PlayersInRoom extends StatelessWidget {
  final RoomStateNewRoom state;
  const PlayersInRoom({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8.0,
      spacing: 8.0,
      children: [
        for (Player player in state.players)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(player.avatar,
                  theme: SvgTheme(currentColor: Colors.white),
                  fit: BoxFit.fitWidth,
                  width: 49),
              Text(
                player.name,
                style: textStyleSmall.copyWith(
                    color: (player.id == userBloc.user!.user!.uid)
                        ? colorMain
                        : colorFront),
              ),
            ],
          ),
      ],
    );
  }
}

class InitialView extends StatefulWidget {
  const InitialView({
    Key? key,
  }) : super(key: key);

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Button(
            text: "CREATE ROOM",
            function: () {
              roomBloc..add(RoomEventNewRoom());
            }),
        Button(
            text: "JOIN ROOM",
            function: () {
              roomBloc..add(RoomEventJoinRoom());
            }),
        BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSqaure(
                  text: "-",
                  function: () {
                    roomBloc..add(RoomEventDicRounds());
                  },
                ),
                ButtonRound(
                  text: roomBloc.rounds.toString(),
                  function: () {},
                ),
                ButtonSqaure(
                  text: "+",
                  function: () {
                    context.read<RoomBloc>().add(RoomEventIncRounds());
                  },
                )
              ],
            );
          },
        ),
        Row(
          children: [
            //LeftArrow()
            //RightArrow()
          ],
        )
      ],
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
