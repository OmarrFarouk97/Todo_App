import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_udemy/compomats/shared_componat/bloc_observer.dart';
import 'package:project_udemy/compomats/shared_componat/componat.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/cubit2.dart';
import 'package:project_udemy/compomats/shared_componat/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'layout/todo_layout/home_layout.dart';
import 'network/local/shared_preferences.dart';
import 'network/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  BlocOverrides.runZoned(
        () {
      late bool? isDark = CacheHelper.getData(key: 'isDark');
      runApp(MyApp(
          ((isDark != null ) ? isDark : false)
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  bool? isDark;

  MyApp(this.isDark,);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()..createDatabase()..changeAppMode(fromShared: isDark),
        ),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode:
              //ThemeMode.light,
              AppCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark,
              home: HomeLayout()
          );
        },
      ),
    );
  }
}