import 'package:flutter/material.dart';

class Data{
  String title , image, description , date ,status;
  int id;

  Data({
    @required this.title,
    @required this.image,
    @required this.description,
    @required this.date,
    @required this.status,
    @required this.id
});

  Data.fromJson(Map<String,dynamic>json){
    image=json['image'];
    title=json['title'];
    description=json['description'];
    date=json['date'];
    status=json['status'];
    id=json['id'];
  }

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map={};
    map['image']=image;
    map['status']=status;
    map['date']=date;
    map['description']=description;
    map['title']=title;
    map['id']=id;

    return map;
  }

  bool isEqual(Data data)
  {
    return (image==data.image&&status==data.status&&date==data.date&&description==data.description&&title==data.title&&id==data.id);
  }
}