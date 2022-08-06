

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';


// ignore: must_be_immutable
class HomeLayout extends StatelessWidget
{


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
       listener: (context, state) {
         if(state is AppInsertDatabaseState){
           Navigator.pop(context);
         }
       },
       builder: (context, state){
         AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppCubit.get(context).titles[cubit.currentIndex],
            ),
            centerTitle: true,
          ),
          body: ConditionalBuilder(

              condition: state is! AppGetDatabaseLoadingState,
            builder: (context) =>cubit.screens[cubit.currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertDatabase(title: titleController.text,
                      time: timeController.text,
                      date: dateController.text
                  );

                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            context: context,
                            controller: titleController,
                            type: TextInputType.text,
                            keyboardType: TextInputType.text,

                            validate: (value) {
                              if (value.isEmpty) {
                                return "الاسم لا يجب ان يكون فارغ";
                              }
                              return null;
                            },
                            label: "اسم المهمة",
                            prefix: Icons.title,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            context: context,
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            type: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text = value!.format(context).toString();

                                print(value.format(context));
                              });
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "الوقت لا يجب ان يكون فارغ";
                              }
                              return null;
                            },
                            label: "وقت المهمة",
                            prefix: Icons.watch_later_outlined,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            context: context,
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            type: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2030-10-15')).then((value) {
                                dateController.text = DateFormat.yMMMd().format(value!);
                              });
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "التاريخ لا يجب ان يكون فارغ";
                              }
                              return null;
                            },
                            label: "تاريخ المهمة",
                            prefix: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 15,
                )
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon:Icons.add,
                      );

                });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon:Icons.edit,
                );


              }
            },



            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'مهام جديدة',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'مهام انتهت',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'مهام فالارشيف',
              ),
            ],
          ),
        );
      },
      ),
    );
  }


}
