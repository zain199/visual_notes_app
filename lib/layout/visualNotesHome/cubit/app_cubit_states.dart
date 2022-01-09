abstract class AppCubitStates {}

class AppCubitInitState extends AppCubitStates {}

class ChangePosition extends AppCubitStates {}

class AppCubitAddNoteSuccessState extends AppCubitStates {}

class AppCubitSelectNoteState extends AppCubitStates {}

class AppCubitGetNotesSuccessState extends AppCubitStates {}

class AppCubitUploadImageSuccessState extends AppCubitStates {}

class AppCubitDeleteNoteSuccessState extends AppCubitStates {}

class AppCubitUploadingImageState extends AppCubitStates {}

class AppCubitGetLastIdState extends AppCubitStates {}


class AppCubitUpdateNoteSuccessState extends AppCubitStates {}

class AppCubitUpdateNoteErrorState extends AppCubitStates {
  final String error;

  AppCubitUpdateNoteErrorState(this.error);
}

