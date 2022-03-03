import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/repository/database_repo.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  DatabaseRepository database = DatabaseRepository();
  List<Message> messages = [];
  bool expanded = false;
  GameBloc() : super(GameInitial()) {
    on<GameEvent>((event, emit) async {
      if (event is GameEventInit) {
        if (roomBloc.roomId != null) {
          messages = await database.getMessages(roomBloc.roomId!);
          database.messagesListener(roomBloc.roomId!);
        }
      }
      if (event is GameEventRefresh) {
        messages = await database.getMessages(roomBloc.roomId!);
        emit(GameInitial());
      }
    });
  }
}
