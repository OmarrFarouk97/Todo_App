import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../compomats/shared_componat/componat.dart';
import '../../../compomats/shared_componat/cubit/cubit2.dart';
import '../../../compomats/shared_componat/cubit/states.dart';


class Archived extends StatelessWidget {
  const Archived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:  ( context, state) {},
      builder: (context,state){
        var tasks = AppCubit.get(context).archivedTasks;
        return tasksBuilder(
            tasks: tasks
        );
      },

    );
  }
}