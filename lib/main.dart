import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterlibbloc/bloc/bloc.dart';

import 'model/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: BlocProvider(
        create: (context) { return PostBloc()..add(PostFetched()); },
        child: PostPage(),
      ),
    );
  }

}

class PostPage extends StatefulWidget {

  @override
  State createState() => PostPageState();

}

class PostPageState extends State<PostPage> {

  final _scrollController = ScrollController();
  final _threshold = 200.0;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostFailure) {
          return Center(
            child: Text(
              "Load Failed...",
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          final successState =  (state as PostSuccess);
          final posts = successState.posts;
          return ListView.builder(
            controller: _scrollController,
            itemCount: successState.hasReachedMax ? posts.length : posts.length + 1,
            itemBuilder: (context, index) =>
                index >= posts.length ? CircularBottomLoadingWidget() : PostWidget(post: posts[index],),);
        }
      },
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    print('On Scroll');
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _threshold) {
      print('On Scroll Bottom Reached');
      _postBloc.add(PostFetched());
    }
  }


}

class PostWidget extends StatelessWidget {

  final Post post;

  const PostWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('${post.id}', style: TextStyle(fontSize: 10),),
      title: Text(post.title),
      subtitle: Text(post.body),
      isThreeLine: true,
      dense: true,
    );
  }
}

class CircularBottomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}