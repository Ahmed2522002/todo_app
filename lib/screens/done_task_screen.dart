import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componants/shard_componant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).doneTasks;
        return tasks.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(18.0),
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
    );
  }
}
