import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterlibbloc/resource/api/PostApi.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final api = PostApi();

  @override
  PostState get initialState => PostInitial();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    try {
      final currentState = state;
      if (event is PostFetched) {
        if (currentState is PostInitial) {
          final posts = await api.fetchPost(0, 20);
          yield PostSuccess(hasReachedMax: false, posts: posts);
          return;
        }

        if (currentState is PostSuccess) {
          final posts = await api.fetchPost(currentState.posts.length, currentState.posts.length + 20);
          yield posts.isNotEmpty
              ? currentState.copyWith(
              posts: currentState.posts + posts, hasReachedMax: false)
              : currentState.copyWith(hasReachedMax: true);
          return;
        }
      }
    } catch(e) {
      print('Error! $e');
      yield PostFailure();
    }
  }

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
      Stream<PostEvent> events,
      TransitionFunction<PostEvent, PostState> transitionFn) {
      return super.transformEvents(events.debounceTime(const Duration(milliseconds:  300)), transitionFn);
  }

  bool get _hasReachedMax => state is PostSuccess && (state as PostSuccess).hasReachedMax;
}
