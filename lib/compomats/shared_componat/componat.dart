import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/cubit2.dart';
import '../../network/styles/colors.dart';
import '../../network/styles/icon_broken.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required String text,
  required Function function,
}) =>
    Container(
      height: 40,
      width: width,
      child: MaterialButton(
        onPressed:(){
          function();
        } ,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  required validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword =false,
  suffixPressed,
  onTab,

})=> TextFormField(
  controller:controller ,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap:onTab,
  validator: validator,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
        prefix
    ),
    suffixIcon: suffix != null? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
          suffix
      ),
    ) : null,
    border: OutlineInputBorder(),
  ),
);


// 3shan a5leh ya3ml y sweb 3shan yms7 a3mlha be dissmissibal we lazm m3aha onDissmissed: (direction ) {}, key  we lazm tb2a string
Widget  buildTaskItem ( Map model, context )
=> Dismissible(

  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      children:  [
        CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 40,
          child: Text(
            '${model['time']}',
          ),

        ),
        SizedBox(
          width:20.0 ,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),


            ],
          ),
        ),
        SizedBox(
          width:20.0 ,
        ),
        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            }, icon:Icon(
          Icons.check_box,
          color: Colors.green,
        )),
        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateData(status: 'archived', id: model['id']);

            },
            icon:Icon(
              Icons.archive_outlined,
              color: Colors.black45,
            )),
        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateData(status: 'new', id: model['id']);

            },
            icon:Icon(
              Icons.keyboard_return,
              color: Colors.black45,
            )),

      ],
    ),
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deletData(id: model['id']);

  },
);



Widget tasksBuilder ({
  required List<Map> tasks
})=> ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=> ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context) ,
    separatorBuilder: (context, index)=>myDivider (),
    itemCount: tasks.length,
  ),
  fallback: (context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.blueGrey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  ),
);


Widget myDivider ()=> Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    width: double.infinity,
    height: 2,
    color: Colors.grey,
  ),
);

void navigateTo(context,widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context)=> widget,
    )
);

void navigateAndFinish (context,widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
      (Route<dynamic>route) => false,
);

Widget defaultTextBottom ({
  required Function function,
  required String text,
})=> TextButton( onPressed: (){function();}, child: Text(text.toUpperCase(),),);


void showToast({
  required String? text,
  required ToastStates state,
})=> Fluttertoast.showToast(
    msg: text!,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor (state),
    textColor: Colors.white,
    fontSize: 16.0
);
//enum 3bara 3n 7aga so8ira b5tar meno we bona2an 3ale ha5taro hy3ml 7aga

enum ToastStates {SUCCESS,ERROR,WARNING}

Color chooseToastColor (ToastStates state)
{
  Color color ;
  switch(state)
  {
    case ToastStates.SUCCESS:
      color= Colors.green;
      break;
    case ToastStates.ERROR:
      color= Colors.red;
      break;
    case ToastStates.WARNING:
      color= Colors.yellow;
      break;
  }
  return color;
}