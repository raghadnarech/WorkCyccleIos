import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class EditTask extends StatefulWidget {
  int? userid;
  int? taskid;
  String? task;
  String? status;

  EditTask({this.status, this.task, this.taskid, this.userid});
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final taskController = TextEditingController();

  bool? repeated;
  @override
  void initState() {
    taskController.text = widget.task!;
    repeated = widget.status == "repeated" ? true : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("تعديل المهمة"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: "المهمة",
                  strutStyle: StrutStyle.fromTextStyle(
                      TextStyle(color: CupertinoColors.black)),
                  decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      border: Border.all(
                          width: 2, color: CupertinoColors.lightBackgroundGray),
                      borderRadius: BorderRadius.circular(5)),
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'حقل مطلوب';
                    }
                  }),
                  controller: taskController,
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    CupertinoSwitch(
                        value: repeated!,
                        onChanged: (value) {
                          setState(() {
                            repeated = value;
                          });
                        }),
                    Text("مكررة"),
                  ],
                ),
                Row(
                  children: [
                    taskProvider.loadingedittask
                        ? Expanded(
                            child: Center(
                            child: CupertinoActivityIndicator(),
                          ))
                        : Expanded(
                            child: CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              onPressed: () async {
                                if (await taskProvider.edit_task(
                                    repeated: repeated,
                                    task: taskController.text,
                                    taskid: widget.taskid,
                                    userid: widget.userid.toString())) {
                                  Navigator.pop(context);
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor:
                                        CupertinoColors.activeGreen,
                                    title: "",
                                    message: "تم تعديل المهمة بنجاح",
                                  ).show(context);
                                  taskController.clear();
                                } else {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: CupertinoColors.systemRed,
                                    title: "",
                                    message: "حدث خطأ يرجى إعادة المحاولة",
                                  ).show(context);
                                  taskController.clear();
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.check_mark),
                                  Text("حفظ")
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
