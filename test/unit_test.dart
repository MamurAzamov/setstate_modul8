import 'package:flutter_test/flutter_test.dart';
import 'package:setstate_modul8/model/post_model.dart';
import 'package:setstate_modul8/services/http_service.dart';

void main(){
  test("Posts are not null", () async {
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    List<Post> posts = Network.parsePostList(response!);
    expect(posts, isNotNull);
  });

  test("Posts are greater then zero", () async {
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    List<Post> posts = Network.parsePostList(response!);
    expect(posts.length, greaterThan(0));
  });

  test("Posts are exactly 100", () async {
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    List<Post> posts = Network.parsePostList(response!);
    expect(posts.length, equals(100));
  });

  test("Check post's title", () async {
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    List<Post> posts = Network.parsePostList(response!);
    expect(posts[1].title.toUpperCase(), equals('QUI EST ESSE'));
  });

}