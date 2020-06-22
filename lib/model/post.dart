
import 'package:equatable/equatable.dart';

class Post extends Equatable {

  final int id;
  final String title;
  final String body;

  Post({this.id, this.title, this.body});

  @override
  List<Object> get props => [this.id, this.title, this.body];

  @override
  String toString() {
    return "id=${this.id}, title=${this.title}, body=${this.body}";
  }
}