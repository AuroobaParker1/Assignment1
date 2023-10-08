import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

Future<List<Comments>> fetchComments() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => Comments.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

void _showCardDetails(BuildContext context, Comments comment) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListTile(
            subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    'Name: ${comment.name}'),
                Text(
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    'Email: ${comment.email}'),
                Text(
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    'Body: ${comment.body}')
              ]),
        ));
      });
}

class Comments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comments(
      {required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body});

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
        postId: json['postId'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
        body: json['body']);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Comments'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        shadowColor: Colors.black,
        backgroundColor: Colors.lightBlue,
        title: Center(child: Text(widget.title)),
      ),
      body: FutureBuilder<List<Comments>>(
        future: fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Comments>? data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: GestureDetector(
                        onTap: () {
                          _showCardDetails(context, data[index]);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 1.0, bottom: 1.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade700,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        data[index].name)),
                              )),
                        )));
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
