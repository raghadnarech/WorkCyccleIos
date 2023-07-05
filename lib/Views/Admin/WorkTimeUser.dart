import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/constant/colors.dart';

class WorkTimeUser extends StatelessWidget {
  WorkTimeUser({this.name, this.userid});
  int? userid;
  String? name;

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('جدول دوام الموظف',
            style: TextStyle(
                color: CupertinoColors.activeBlue.darkHighContrastColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: employeeProvider.loadinguserprofile
            ? SizedBox(
                height: height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "جدول الدوام",
                        style: headStyle,
                      ),
                      employeeProvider.loadDownloadExcel
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoActivityIndicator(),
                            )
                          : CupertinoButton(
                              color: CupertinoColors.activeGreen,
                              onPressed: () async {
                                if (await employeeProvider.getExcelWorktime(
                                    userid: userid, name: name)) {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor:
                                        CupertinoColors.activeGreen,
                                    message: "تم حفظ الملف في التنزيلات",
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: CupertinoColors.systemRed,
                                    title: "تعذر طلب الإذن",
                                    message: "حدث خطأ يرجى إعادة المحاولة",
                                  ).show(context);
                                }
                              },
                              child: Row(
                                children: [
                                  Text("حفظ كـ Excel"),
                                  Icon(Icons.download)
                                ],
                              ))
                    ],
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
                              label: Text("التاريخ"),
                            ),
                            DataColumn(
                              label: Text("بداية الدوام"),
                            ),
                            DataColumn(
                              label: Text("نهاية الدوام"),
                            ),
                            DataColumn(
                              label: Text("ساعات الدوام"),
                            ),
                          ],
                          rows: employeeProvider.profileUser!.workTime!
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(Text(e.date!)),
                                  DataCell(Text(e.in_time!)),
                                  DataCell(Text(e.out_time!)),
                                  DataCell(Text(e.total!)),
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
