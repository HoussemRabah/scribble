import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/UI/widgets/decor.dart';
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
        BlocProvider.value(
            value: roomBloc..add(RoomEventInit(context: context))),
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
            if (state is RoomStateJoinRoom) return JoinView();
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

class JoinView extends StatelessWidget {
  const JoinView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onSubmitted: (code) {
              roomBloc..add(RoomEventJoinRoomStart(roomId: code));
            },
            style: textStyleBig,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "ROOM CODE",
                hintStyle:
                    textStyleBig.copyWith(color: colorBlack, shadows: [])),
          ),
        ),
        Text(
          roomBloc.error,
          style: textStyleError,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              roomBloc..emit(RoomInitial());
            },
            child: Cadre(
              child: Container(
                color: colorBack,
                width: 80,
                height: 50,
                padding: EdgeInsets.all(8.0),
                child: Center(child: Icon(Icons.arrow_left)),
              ),
            ),
          ),
        )
      ],
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
          "ROOM ID : \n${state.id}",
          style: textStyleBig,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 32.0,
        ),
        // players
        PlayersInRoom(state: state),

        SizedBox(
          height: 32.0,
        ),
        // play
        if (roomBloc.iamTheCreator)
          Button(
              text: "play",
              function: () {
                roomBloc..add(RoomEventStartTheGame());
              }),
        SizedBox(
          height: 8.0,
        ),
        Button(
            text: "exit",
            function: () {
              roomBloc..emit(RoomInitial());
            })
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
              SizedBox(
                height: 8.0,
              ),
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
            return Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
              child: AvtarSelctor(),
            );
          },
        ),
        Text(userBloc.userName ?? "ops null error ):",
            style: textStyleBig.copyWith(
              color: Colors.white,
            )),
        SizedBox(
          height: 8.0,
        ),
        Button(
            text: "CREATE ROOM",
            function: () {
              roomBloc..add(RoomEventNewRoom());
            }),
        SizedBox(
          height: 8.0,
        ),
        Button(
            text: "JOIN ROOM",
            function: () {
              roomBloc..add(RoomEventJoinRoom());
            }),
        SizedBox(
          height: 32.0,
        ),
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
            refreshAvtars(0);

            context.read<UserBloc>().add(UserEventChangeAvatar(
                newAvatar: avatars[1])); // just to rebuild widget
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
            refreshAvtars(2);

            context.read<UserBloc>().add(UserEventChangeAvatar(
                newAvatar: avatars[1])); // just to rebuild widget
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
