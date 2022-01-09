import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit_states.dart';
import 'package:visual_notes_app/models/visualNotesData/data.dart';
import 'package:visual_notes_app/shared/components/components.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppCubitInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  int lastId;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  String status = '';
  List<String> selectStatus = ['opened', 'closed'];
  List<Data> data = [];


  void restNoteData() {
    titleController.text = '';
    descriptionController.text = '';
    status = '';
    imageUrl = '';
  }

  void selectNoteState(val) {
    status = val;
    emit(AppCubitSelectNoteState());
  }

  XFile selectedFile;
  File imageFile;
  String imageUrl = '';

  void PickImage(context) async {
    selectedFile = null;
    imageFile = null;
    imageUrl = '';
    selectedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 20);
    if (selectedFile != null) {
      imageFile = File(selectedFile.path);
      UploadImage(imageFile, context);
    } else {
      showToast('something went wrong', Colors.red, context);
    }
  }

  bool CheckDataReady() {
    return imageUrl.isNotEmpty &&
        status.isNotEmpty;
  }

  void UploadImage(imageFile, context) async{


    if(await checkInternet()) {
      emit(AppCubitUploadingImageState());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/' + DateTime.now().toString())
          .putFile(imageFile)
          .then((val) {
        val.ref.getDownloadURL().then((value) {
          imageUrl = value;
          emit(AppCubitUploadImageSuccessState());
        }).catchError((onError) {
          print(onError.toString());
          showToast(onError.toString(), Colors.red, context);
        });
      });
    }else {
      showSnackBar(context);
    }
  }

  void getLastId()async
  {
      FirebaseFirestore.instance
          .collection('lastId')
          .doc('lastId')
          .get()
          .then((value) {
        lastId=value.data()['lastId'];
        emit(AppCubitGetLastIdState());
      });
  }

  void addNote(String collectionName, int id, Map<String, dynamic> data, context) async{
    if(await checkInternet()) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id.toString())
          .set(data)
          .whenComplete(() {
        showToast('Visual Note Added Successfully', colorApp, context);
        emit(AppCubitAddNoteSuccessState());
      }).catchError((onError)=>print(onError.toString()));
    }else
      showSnackBar(context);

  }

  void updateLastIdAndAddNote(collectionName, docId,  data, context)async
  {
    if(await checkInternet()) {
      lastId++;
      FirebaseFirestore.instance
          .collection('lastId')
          .doc('lastId')
          .update({'lastId': lastId}).whenComplete(() {
        addNote(collectionName, docId, data, context);
      }).catchError((onError) {
        showToast(onError.toString(), Colors.red, context);
      });
    }else
      showSnackBar(context);
  }

  void getNotes(String collectionName)async {

      FirebaseFirestore.instance
          .collection(collectionName)
          .snapshots()
          .listen((event) {
        data = [];
        event.docs.forEach((element) {
          data.add(Data.fromJson(element.data()));
        });

        if (data.length == event.docs.length) {
          emit(AppCubitGetNotesSuccessState());
        }
      });

  }

  void deleteNote(id, index, context)async {
    if(await checkInternet()) {
      FirebaseFirestore.instance
          .collection('notes')
          .doc(id.toString())
          .delete()
          .whenComplete(() {
        showToast('Deleted Successfully', colorApp , context);
        emit(AppCubitDeleteNoteSuccessState());
      });
    }else
      showSnackBar(context);

  }


  void updateNote(String collectionName, docId, Map<String, dynamic> data,context)async{

    if(await checkInternet()) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId.toString())
          .update(data)
          .whenComplete((){
        emit(AppCubitUpdateNoteSuccessState());
      });
    }else
      showSnackBar(context);

  }

}
