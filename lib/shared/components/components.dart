import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

Widget sharedTextButton({
  @required Function onPress,
  @required String text,
}) {
  return TextButton(onPressed: onPress, child: Text(text.toUpperCase()));
}

Widget sharedMaterialButton({
  double width = double.infinity,
  double height = 50.0,
  Color background = Colors.blue,
  double radius = 0.0,
  bool isUppercase = true,
  @required Function pressed,
  @required String txt,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: pressed,
      child: Text(
        txt.toUpperCase(),
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

Widget sharedTextFormField({
  bool isPassword = false,
  @required TextEditingController controller,
  @required String text,
  Function validate,
  @required TextInputType type,
  Function onTap,
  Function suffixPressed,
  Color iconColor = Colors.blue,
  double radius = 0.0,
  IconData suffixIcon,
}) =>
    TextFormField(
      validator: validate,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(
                  suffixIcon,
                  color: colorApp,
                ),
                onPressed: suffixPressed,
              )
            : null,
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      keyboardType: type,
      onTap: onTap,
    );

Widget defaultAppBar({
  @required context,
  String title,
  List<Widget> actions,
}) {
  return AppBar(
    title: Text(title),
    actions: actions,
    //titleSpacing: 5,
  );
}

navigateTo({
  @required context,
  @required screen,
}) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

navigateAndReplace({
  @required context,
  @required screen,
}) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => screen), (route) => false);
}

showToast(String msg, Color bg, context) {
  Toast.show(
    msg,
    context,
    backgroundColor: bg,
    duration: Toast.LENGTH_LONG,
  );
}

Future<bool> checkInternet() {
  return Connectivity().checkConnectivity().then((ConnectivityResult value) {
    return  value != ConnectivityResult.none;
  });
}

  void  showSnackBar(context) {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     backgroundColor: Colors.red,
    content: Row(
      children:  const [
        Icon(Icons.info_outline,),
        SizedBox(width: 10.0,),
        Text('No Internet Connection')
      ],
    ),
  ),
   );
}
