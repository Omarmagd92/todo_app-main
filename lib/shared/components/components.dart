import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultFormField({
  context,
  required TextEditingController controller,
  required TextInputType keyboardType,
  TextInputType? type,
  bool isPassword = false,
  bool enabled = true,
  onSubmit,
  onChange,
  onTap,
  required FormFieldValidator validate,
  String? label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClikable = true,
  String? labelText,
  BorderRadius borderRadius = BorderRadius.zero,
  Color? fillColor,
  Color? enabledBorderColor,
  Color? focusedBorderColor,
  TextStyle? style,
  TextStyle? labelStyle,
  bool hasBorder = true,
  OutlineInputBorder? focusedBorder,
  OutlineInputBorder? enabledBorder,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: style ?? TextStyle(),
      decoration: InputDecoration(
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        labelText: labelText,
        labelStyle: labelStyle ?? TextStyle(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ))
            : null,
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          )
        ]),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(
          id: model['id'],
        );
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              size: 100,
              color: Colors.grey,
            ),
            Text('لا يوجد مهام جديدة من فضلك اضف مهمة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );
