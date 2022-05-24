import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/states.dart';
import 'package:project_udemy/network/local/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../moudules/todo_app/Archived/Archived.dart';
import '../../../moudules/todo_app/done/done.dart';
import '../../../moudules/todo_app/new_taskes/new_tasks.dart';

class AppCubit extends Cubit <AppStates>
{
  AppCubit() : super(AppInitialState());


  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    Taskes(),
    Done(),
    Archived(),
  ];
  List<String> title = [
    'Tasks',
    'Done',
    'Archived',
  ];

  void changeIndex (int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarStates());
  }

 late Database database;

  List <Map> newTasks = [];
  List <Map> doneTasks = [];
  List <Map> archivedTasks = [];


  void createDatabase()  {
      openDatabase(
      'todo.db',
      version: 1,
        onCreate: (database, version) //async
        {
          print('database created');
          //await
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
              .then((value)
          {
            print('table created');
          }).catchError((error) {
            print('Error When Created Table ${error.toString()}');
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
          print('database Opened');
        },
        ).then((value)
        {
        database = value;
    emit(AppCreateDatabaseState());
        });
  }

   insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn)  {
      return  txn.rawInsert(
        'INSERT INTO tasks (title, time , date, status) VALUES("$title", "$time", "$date", "new")',
      ).then((value) {
        print('$value insert successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error) {
        print('Error when Inserting New Record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database)
  {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM tasks').then((value) {
        // print(tasks[0]['title']);
        //print(tasks[1]['date']);
        value.forEach((element)
            {

       if (element['status']== 'new')

         newTasks.add(element);

       else if (element['status']== 'done')
         doneTasks.add(element);

       else archivedTasks.add(element);

       });
        emit(AppGetDatabaseState());

      });
  }


  bool isBottomShetShown = false;
  IconData fatIcon = Icons.edit;


  void changeBottomSheetState ({
  required bool isShow,
    required IconData icon,
})
  {
    isBottomShetShown = isShow;
    fatIcon = icon;
    emit(AppChangeBottomSheetStates());
  }


  void updateData({
  required String status,
    required int id,

  }) async
  {

     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],).then((value) {
          emit(AppUpdateDatabaseState());
          getDataFromDatabase(database);
     });

    print('updated: $status');

  }


  void deletData({
    required int id,
  }) async
  {

    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).
    then((value) {
      emit(AppDeletDatabaseState());
      getDataFromDatabase(database);
    });

    print('updated: $id');

  }


  bool isDark= false;
  void changeAppMode({ bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeAppMode());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeAppMode());
      });
    }
  }
}