import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit_states.dart';
import 'package:visual_notes_app/modules/addNote/addNoteScreen.dart';
import 'package:visual_notes_app/modules/editNote/editNoteScreen.dart';
import 'package:visual_notes_app/shared/components/components.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: "Home",
            actions: [
              OutlinedButton(
                onPressed: () {
                  navigateTo(context: context, screen: AddNoteScreen());
                },
                child: Text(
                  "Add New Visual Note",
                  style: TextStyle(
                    color: colorApp,
                  ),
                ),
              )
            ],
          ),
          body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildItem(context, index);
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 1,
            ),
            itemCount: cubit.data.length,
          ),
        );
      },
    );
  }


  Widget buildItem(BuildContext context, index) {
    var cubit = AppCubit.get(context);

    return FocusedMenuHolder(
      menuItems: [
        FocusedMenuItem(
          backgroundColor: Colors.black26,
          title: Text("Edit" , style: Theme.of(context).textTheme.subtitle1),
          onPressed: () {navigateTo(context: context, screen: EditNoteScreen(cubit.data[index]));},
          trailingIcon: const Icon(Icons.edit),
        ),

        FocusedMenuItem(
          backgroundColor: Colors.black26,
          title: Text("Delete" ,style: Theme.of(context).textTheme.subtitle1),
          onPressed: () {cubit.deleteNote(cubit.data[index].id, index, context);},
          trailingIcon: const Icon(Icons.delete ),
        )
      ],
      onPressed: () {},
      openWithTap: true,
      child: Card(
        elevation: 20,
        color: colorApp,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 10, top: 35),
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: Row(children: [
              Image(
                image: NetworkImage(cubit.data[index].image),
                width: 100,
                height: 120,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              cubit.data[index].title,
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            flex: 1,
                              child:Text('ID : '+cubit.data[index].id.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                        ],
                      ),
                      flex: 3,
                    ),

                    Expanded(
                      flex: 3,
                      child: Text(
                        cubit.data[index].description,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.grey[300]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cubit.data[index].status,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.grey[300]),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cubit.data[index].date,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
