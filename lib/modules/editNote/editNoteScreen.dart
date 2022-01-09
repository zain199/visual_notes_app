import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit_states.dart';
import 'package:visual_notes_app/models/visualNotesData/data.dart';
import 'package:visual_notes_app/shared/components/components.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

class EditNoteScreen extends StatelessWidget {

  final Data data;

  EditNoteScreen(this.data);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    cubit.titleController.text = data.title;
    cubit.descriptionController.text = data.description;
    cubit.status = data.status;

    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {
        if(state is AppCubitUpdateNoteSuccessState) {
          showToast('Data Updated Successfully', colorApp, context);
        }

      },
      builder: (context, state) {

        return WillPopScope(
          onWillPop: () async {
                cubit.restNoteData();
                return true;
          },
          child: Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: "Edit Visual Note",
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
                          Text('Visual Note Image : ' , style: Theme.of(context).textTheme.bodyText1.copyWith(
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



                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Image(image: NetworkImage(cubit.imageUrl!=''?cubit.imageUrl:data.image) , fit: BoxFit.cover,),
                            ),
                            if(state is AppCubitUploadingImageState)
                              Center(child: CircularProgressIndicator(color: colorApp,)),
                          ],
                        ),

                      Divider(
                        color: colorApp,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      sharedTextFormField(
                        controller: cubit.titleController,
                        validate: (String val) {
                          if(val.isEmpty) return "Title Can Not Be Empty";
                          return null;
                        },
                        text: 'Enter Title',
                        type: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      sharedTextFormField(
                          controller: cubit.descriptionController,
                          text: 'Enter Description',
                          validate: (String val) {
                            if(val.isEmpty) return "Description Can Not Be Empty";
                            return null;
                          },
                          type: TextInputType.text),
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
                              Data newData=Data(
                                id: data.id,
                                title: cubit.titleController.text,
                                image: cubit.imageUrl!=''?cubit.imageUrl:data.image,
                                description: cubit.descriptionController.text,
                                date: data.date,
                                status: cubit.status,
                              );
                              if(!newData.isEqual(data)) {
                                if (cubit.formKey.currentState.validate()) {
                                  cubit.updateNote(
                                    'notes',
                                    data.id,
                                    newData.toMap(),
                                    context,
                                  );
                                  cubit.restNoteData();
                                  Navigator.pop(context);
                                } else {
                                  showToast('data not ready', Colors.red, context);
                                }
                              }else
                                {Navigator.pop(context);}
                            },
                            child: const Text("Update" , style: TextStyle(color: Colors.white , fontSize: 20),)),
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
