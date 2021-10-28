import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bsr/bloc/base/base_state.dart';

part 'single_game_state.dart';

class SingleGameCubit extends Cubit<SingleGameState> {
  SingleGameCubit() : super(SingleGameState());
}
