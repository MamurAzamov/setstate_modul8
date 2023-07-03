import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:setstate_modul8/services/http_service.dart';
import 'package:setstate_modul8/services/log_service.dart';

import '../model/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      isLoading = false;
      if (response != null) {
        items = Network.parsePostList(response);
      } else {
        items = [];
      }
    });
  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    setState(() {
      if (response != null) {
        _apiPostList();
      } else {}
      isLoading = false;
    });
  }

  void _apiPostUpdate(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.PUT(
        Network.API_UPDATE + post.id.toString(), Network.paramsUpdate(post));
    setState(() {
      if (response != null) {
        _apiPostList();
      } else {}
      isLoading = false;
    });
  }


  Future<void> createData() async {
    const url = 'http://jsonplaceholder.typicode.com/posts'; // API manzilingizni ko'rsating

    final newData = {
      'title': 'Yangi sarlavha',
      'body': 'Yangi matn',
      'userId': 1,
    };
    final response = await Dio().post(url, data: newData);

    setState(() {
      isLoading = true;
      if (response.statusCode == 201) {
        LogService.i('Malumot yaratildi');
      } else {
        LogService.e('Malumot yaratishda xatolik: ${response.statusCode}');
      }
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("setState"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return itemOfPost(items[index]);
            },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          createData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {},
          ),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _apiPostUpdate(post);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: "Update",
            )
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {},
          ),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _apiPostDelete(post);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title.toUpperCase()),
              const SizedBox(
                height: 5,
              ),
              Text(post.body),
            ],
          ),
        ));
  }
}
