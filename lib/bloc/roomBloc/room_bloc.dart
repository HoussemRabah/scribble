import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  int rounds = 1;
  RoomBloc() : super(RoomInitial()) {
    on<RoomEvent>((event, emit) {
      if (event is RoomEventIncRounds) {
        if (rounds + 1 <= 20) rounds++;
      }
      if (event is RoomEventDicRounds) {
        if (rounds - 1 > 0) rounds--;
      }
    });
  }
}
