import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Admin/EditTask.dart';
import 'package:qr_app/Views/Admin/ImagesTasks.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:qr_app/constant/url.dart';

class TaskUser extends StatelessWidget {
  int? userid;
  TaskUser({this.userid});

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text("مهام الموظف",
            style: TextStyle(
                color: CupertinoColors.activeBlue.darkHighContrastColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: employeeProvider.loadinguserprofile
            ? SizedBox(
                height: height,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Text(
                    "المهام",
                    style: headStyle,
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 5,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("المهمة"),
                            ),
                            DataColumn(
                              label: Text("الحالة"),
                            ),
                            DataColumn(
                              label: Text("الخيارات"),
                            ),
                          ],
                          rows: employeeProvider.profileUser!.task!
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(Text(e.task!)),
                                  DataCell(Text(e.status! == "repeated"
                                      ? "مكررة"
                                      : e.status! == "finished"
                                          ? "منتهية"
                                          : "غير منتهية")),
                                  DataCell(Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (e.status == "repeated") {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ImagesTasks(
                                                          task: e.listimage!),
                                                ));
                                          } else {
                                            if (e.status == "finished") {
                                              showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CupertinoButton(
                                                              child: Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            Divider(),
                                                            InstaImageViewer(
                                                                child: Image
                                                                    .network(
                                                              "$urlImage/${e.image!}",
                                                            )),
                                                          ],
                                                        ),
                                                      ));
                                            } else {
                                              Flushbar(
                                                duration: Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                                title: "المهمة غير منتهية",
                                                message:
                                                    "المهمة غير منتهية, لايوجد صورة لعرضها",
                                              ).show(context);
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.transparent,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          print(e.id);
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => EditTask(
                                                    status: e.status!,
                                                    task: e.task,
                                                    taskid: e.id,
                                                    userid: userid),
                                              ));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.transparent,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoAlertDialog(
                                              content: Text(
                                                  "هل أنت متأكد من حذف هذه المهمة"),
                                              actions: [
                                                CupertinoButton(
                                                    onPressed: () async {
                                                      if (await taskProvider
                                                          .deleteTask(e.id!)) {
                                                        Flushbar(
                                                          duration: Duration(
                                                              seconds: 3),
                                                          backgroundColor:
                                                              CupertinoColors
                                                                  .activeGreen,
                                                          title: "",
                                                          message:
                                                              "تم حذف المهمة بنجاح",
                                                        ).show(context);
                                                        Navigator.pop(context);

                                                        employeeProvider
                                                            .getUserProfile(
                                                                userid);
                                                      }
                                                    },
                                                    child: taskProvider
                                                            .loadingdelete
                                                        ? CupertinoActivityIndicator()
                                                        : Text("نعم")),
                                                CupertinoButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("خروج"))
                                              ],
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )),
                                ]),
                              )
                              .toList()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
