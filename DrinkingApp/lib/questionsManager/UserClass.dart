import 'package:flutter/cupertino.dart';

class UserClass {
  late String username;
  late String photopath;

  FeedManager(String username, String photopath) {
      this.username = username;
      this.photopath = photopath;
  }

  String getUsername(){
    return username;
  }

  String getPhotoPath(){
    return photopath;
  }
}