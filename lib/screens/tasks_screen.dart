import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:todo_app/componants/shard_componant.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

import '../componants/constants.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
          BlocConsumer<TodoCubit, TodoStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var tasks = TodoCubit.get(context).tasks;

              return tasks.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => BuildTaskItem(
                          tasks[index],
                          context,
                        ),
                        separatorBuilder: (context, index) => const SizedBox(),
                        itemCount: tasks.length,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: Image.network(
                                'https://cdn3d.iconscout.com/3d/premium/thumb/task-not-found-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--checklist-no-tasklist-list-empty-states-pack-miscellaneous-illustrations-4009510.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const Text(
                              'No Tasks Yet!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          )
        ],
      )),
    );
  }
}
