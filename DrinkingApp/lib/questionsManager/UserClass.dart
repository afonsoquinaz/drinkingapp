import 'package:flutter/cupertino.dart';

class UserClass {
  late String username;
  late String photopath;

  UserClass(this.username, this.photopath);

  String getUsername(){
    return username;
  }

  String getPhotoPath(){
    return photopath;
  }
}