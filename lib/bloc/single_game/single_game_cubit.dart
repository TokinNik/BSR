import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:temp_app/bloc/base/base_state.dart';

part 'single_game_state.dart';

class SingleGameCubit extends Cubit<SingleGameState> {
  SingleGameCubit() : super(SingleGameState());
}
