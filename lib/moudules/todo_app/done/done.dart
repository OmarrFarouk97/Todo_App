import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../compomats/shared_componat/componat.dart';
import '../../../compomats/shared_componat/cubit/cubit2.dart';
import '../../../compomats/shared_componat/cubit/states.dart';



class Done extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:  ( context, state) {},
      builder: (context,state){
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(
            tasks: tasks
        );
      },

    );

  }
}