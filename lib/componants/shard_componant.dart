import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

DateTime now = DateTime.now();
String currentDate = DateFormat('MMMM d, yyyy').format(now);
String currentDay = DateFormat('EEEE').format(now);
Widget defualtFormfeild({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  required String? Function(String?) valid, // Specify correct function type
  required String label,
  required IconData prefix,
  IconData? sufix,
  bool isPassword = false,
  void Function()? onPressed,
  void Function()? ontap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: ontap,
      validator: valid,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: sufix != null
            ? IconButton(onPressed: onPressed, icon: Icon(sufix))
            : null,
        border: OutlineInputBorder(),
      ),
      obscureText: isPassword,
    );

Widget BuildTaskItem(Map model) => SwipeTo(
  child: Container(
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35), color: Colors.white),
        width: double.infinity,
        height: 100,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 35,
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
);
Widget BuildTasksScreen() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Hello Friend👋'),
            const Spacer(),
            GestureDetector(
              child: const Icon(Icons.dark_mode),
              onTap: () {},
            )
          ],
        ),
        const Text(
          'Ready to do your Daily Tasks??',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Today\'s '),
            Text(
              currentDay,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue),
            )
          ],
        ),
        Text(
          currentDate,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 90,
              ),
              const CircleAvatar(
                radius: 2,
                backgroundColor: Colors.black,
              ),
              Container(
                color: Colors.black,
                height: 1.5,
                width: 260,
              )
            ],
          ),
        ),
        const Row(
          children: [
            Text(
              'Ongoing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.task,
              color: Colors.blue,
              size: 30,
            )
          ],
        ),
      ],
    );
