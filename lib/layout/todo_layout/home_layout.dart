import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_udemy/compomats/shared_componat/componat.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/cubit2.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/states.dart';


class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  // @override
  // void initState() {
  //   createDatabase();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {

          //3shan ashl 3lia badl m3aml kul da AppCubit.get(context) . kaza eli 3ndi
          // momokn a3ml meno object
          AppCubit cubit=  AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  AppCubit.get(context).title[cubit.currentIndex]
              ),
            ),
            body:  cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomShetShown) {
                  if (formKey.currentState!.validate()) {

                    cubit.insertDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                    // insertDatabase(
                    //   time: timeController.text,
                    //   title: titleController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //
                    //   //isBottomShetShown = false;
                    //
                    //   // setState(() {
                    //   //   fatIcon = Icons.edit;
                    //   // });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: "task Title",
                                    prefix: Icons.title),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTab: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: "task Time",
                                    prefix: Icons.watch_later_outlined),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTab: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-06-20'),
                                      ).then((value) {
                                        // print(DateFormat.yMMMd().format(value!));
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: "task Date",
                                    prefix: Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      )
                      //3shan lw aflto be ede mybozshe
                      .closed.then((value) {
                        cubit.changeBottomSheetState(
                            isShow: false,
                            icon: Icons.edit
                        );
                    // cubit.isBottomShetShown = false;
                    // setState(() {
                    //   fatIcon = Icons.edit;
                    // });
                  });

                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add)
                  ;
                  //cubit.isBottomShetShown = true;
                  // setState(() {
                  //   fatIcon = Icons.add;
                  // });
                }
              },
              child: Icon(cubit.fatIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index)
              {
                AppCubit.get(context).changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }


}
