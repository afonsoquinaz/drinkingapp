import 'package:flutter/cupertino.dart';

class UserClass {
  String username;
  String photoPath;
  List<String> picsFromCamera=[];

  UserClass(this.username, this.photoPath);

  String getUsername(){
    return username;
  }

  String getPhotoPath(){
    return photoPath;
  }

  setPhotoPath(String newPath){
    photoPath = newPath;
  }
}