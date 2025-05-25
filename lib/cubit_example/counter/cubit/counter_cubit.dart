import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(0));

  void increment() {
    emit(CounterState(state.count + 1));
  }

  void decrement() {
    if (state.count > 0) {
      emit(CounterState(state.count - 1));
    }
  }
}