import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit_states.dart';
import 'package:visual_notes_app/models/visualNotesData/data.dart';
import 'package:visual_notes_app/shared/components/components.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

class AddNoteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
                cubit.restNoteData();
                return true ;
          },
          child: Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: "Add New Visual Note",
            ),
            body: Container(
              height: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Upload Visual Note Image : ' , style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black
                          ),),

                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: colorApp,
                            onPressed: () {
                              cubit.PickImage(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(state is AppCubitUploadingImageState)
                         Center(child: CircularProgressIndicator(color: colorApp,)),
                      if(cubit.imageUrl != '')
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Image(image: NetworkImage(cubit.imageUrl ) , fit: BoxFit.cover,),
                      ),

                      Divider(
                        color: colorApp,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      sharedTextFormField(
                        controller: cubit.titleController,
                        text: 'Enter Title',
                        type: TextInputType.text,
                        validate: (String val) {
                          if(val.isEmpty) return "Title Can Not Be Empty";
                              return null;
                        }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      sharedTextFormField(
                          controller: cubit.descriptionController,
                          text: 'Enter Description',
                          type: TextInputType.text,
                          validate: (String val) {
                            if(val.isEmpty) return "Description Can Not Be Empty";
                            return null;
                          }
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        value: cubit.status.isNotEmpty ? cubit.status : null,
                        isExpanded: true,
                        hint: const Text("Select Status"),
                        items: cubit.selectStatus.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (val) {
                          cubit.selectNoteState(val);
                        },
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      Container(
                        width: double.infinity,
                        color: colorApp,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none
                          ),
                            onPressed: () {
                              if (cubit.CheckDataReady() && cubit.formKey.currentState.validate()) {
                                cubit.updateLastIdAndAddNote(
                                  'notes',
                                  cubit.lastId,
                                  Data(
                                    id: cubit.lastId,
                                    title: cubit.titleController.text.trim(),
                                    image: cubit.imageUrl,
                                    description: cubit.descriptionController.text.trim(),
                                    date: DateFormat('dd/MM/yyyy HH:mm a')
                                        .format(DateTime.now()),
                                    status: cubit.status,
                                  ).toMap(),
                                  context,
                                );
                                cubit.restNoteData();
                                Navigator.pop(context);
                              } else {
                                showToast('data not ready', Colors.red, context);
                              }
                            },
                            child: const Text("Add" , style: TextStyle(color: Colors.white , fontSize: 20),)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
        );
      },
    );
  }
}
