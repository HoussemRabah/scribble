import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scribble/UI/widgets/laoding.dart';
import 'package:scribble/UI/widgets/layouts.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/bloc/userBloc/user_bloc.dart';
import 'package:scribble/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

UserBloc userBloc = UserBloc();
RoomBloc roomBloc = RoomBloc();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBack,
      body: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: userBloc..add(UserEventInit(context: context)),
            ),
            BlocProvider.value(value: roomBloc),
          ],
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserStateLoading) return LoadingView(state: state);
              if (state is UserStateWriteName) return WriteView();
              return Container();
            },
          )),
    );
  }
}

class LoadingView extends StatelessWidget {
  final UserStateLoading state;
  const LoadingView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CentreScreenLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SCRIBBLE GAME",
            style: textStyleTitle,
          ),
          SizedBox(height: 50.0),
          LoadingBar(process: state.process),
        ],
      ),
    );
  }
}

class WriteView extends StatelessWidget {
  const WriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CentreScreenLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SCRIBBLE GAME",
            style: textStyleTitle,
          ),
          SizedBox(height: 50.0),
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: colorFront,
                border: Border(
                  top: BorderSide(color: colorMain),
                  left: BorderSide(color: colorMain),
                  right: BorderSide(color: colorMain),
                  bottom: BorderSide(color: colorMain),
                )),
            child: TextField(
              onSubmitted: (username) {
                context
                    .read<UserBloc>()
                    .add(UserEventNewUser(username: username));
              },
              style: textStyleBig,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "NICKNAME"),
            ),
          )
        ],
      ),
    );
  }
}
