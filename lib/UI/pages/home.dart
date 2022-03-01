import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scribble/UI/widgets/laoding.dart';
import 'package:scribble/bloc/userBloc/user_bloc.dart';
import 'package:scribble/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

UserBloc userBloc = UserBloc();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBack,
      body: MultiBlocProvider(
          providers: [BlocProvider.value(value: userBloc)],
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserStateLoading) return LoadingView(state: state);
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
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(
              "SCRIBBLE GAME",
              style: textStyleTitle,
            ),
            LoadingBar(process: state.process),
          ],
        ));
  }
}
