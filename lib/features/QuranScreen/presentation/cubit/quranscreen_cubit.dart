import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quranscreen_state.dart';

class QuranscreenCubit extends Cubit<QuranscreenState> {
  QuranscreenCubit() : super(QuranscreenInitial());
}
