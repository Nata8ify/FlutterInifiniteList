
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBlocDelegate extends BlocDelegate {

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Post Bloc onTransition! => $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print('Post Bloc Error! => $error');
    super.onError(bloc, error, stackTrace);
  }
}