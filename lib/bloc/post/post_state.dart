
import 'package:equatable/equatable.dart';
import 'package:flutterlibbloc/model/post.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostFailure extends PostState {}

class PostSuccess extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostSuccess({this.posts, this.hasReachedMax});

  PostSuccess copyWith({List<Post> posts, bool hasReachedMax}) {
    return PostSuccess(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() {
    return "posts=$posts, hasReachedMax=$hasReachedMax";
  }
}
