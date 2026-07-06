import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class BlocObserverService extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log('@BLOC_OBSERVER:: onCreate bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('@BLOC_OBSERVER:: onEvent bloc: ${bloc.runtimeType} ** event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('@BLOC_OBSERVER:: onChange bloc: ${bloc.runtimeType} ** change: $change');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    log('@BLOC_OBSERVER:: onTransition bloc: ${bloc.runtimeType} ** transition: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('@BLOC_OBSERVER:: onError bloc: ${bloc.runtimeType} ** error: $error ** stackTrace: $stackTrace');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log('@BLOC_OBSERVER:: onClose bloc: ${bloc.runtimeType}');
  }
}
