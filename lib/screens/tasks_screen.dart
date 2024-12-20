import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/componants/shard_componant.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

import '../componants/constants.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildTasksScreen(),
          SizedBox(
            height: 20,
          ),
          BlocConsumer<TodoCubit,TodoStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var tasks = TodoCubit.get(context).tasks;

              return Expanded(
                child: tasks.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) =>
                            BuildTaskItem(tasks[index]),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: tasks.length,
                      )
                    : const Center(
                        child: Text('No tasks yet, add some!'),
                      ),
              );
            },
          )
        ],
      )),
    );
  }
}
