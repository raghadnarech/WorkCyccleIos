import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Views/Admin/HomePageAdmin.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:qr_app/constant/colors.dart';

class EditUserProfile extends StatefulWidget {
  EditUserProfile(
      {this.userid,
      this.name,
      this.phone,
      this.dateTime,
      this.housing_allowance,
      this.number_idintity,
      this.other,
      this.salary,
      this.total,
      this.transfer_allowance});
  int? userid;
  String? name;
  String? phone;
  String? number_idintity;
  String? dateTime;
  var salary;
  var housing_allowance;
  var transfer_allowance;
  var other;
  var total;

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

final dateController = TextEditingController();
final namecontroller = TextEditingController();
final phonecontroller = TextEditingController();
final salaryController = TextEditingController();
final housing_allowanceController = TextEditingController();
final number_idintityController = TextEditingController();
final otherController = TextEditingController();
final totalController = TextEditingController();
final transfer_allowanceController = TextEditingController();

class _EditUserProfileState extends State<EditUserProfile> {
  var total;
  var salary;
  var housing_allowance;
  var other;
  var transfer_allowance;
  sumtotal() {
    salary = num.tryParse(salaryController.text)?.toDouble() ?? 0;
    housing_allowance =
        num.tryParse(housing_allowanceController.text)?.toDouble() ?? 0;
    transfer_allowance =
        num.tryParse(transfer_allowanceController.text)?.toDouble() ?? 0;
    other = num.tryParse(otherController.text)?.toDouble() ?? 0;
    total = salary + housing_allowance + transfer_allowance + other;
    setState(() {
      totalController.text = total.toString();
    });
  }

  @override
  void initState() {
    sumtotal();
    namecontroller.text = widget.name!;
    phonecontroller.text = widget.phone!;
    salaryController.text = widget.salary!.toString();
    dateController.text = widget.dateTime!.toString();
    housing_allowanceController.text = widget.housing_allowance!.toString();
    number_idintityController.text = widget.number_idintity!.toString();
    otherController.text = widget.other!.toString();
    totalController.text = widget.total!.toString();
    transfer_allowanceController.text = widget.transfer_allowance!.toString();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.clear();
    phonecontroller.clear();
    dateController.clear();
    salaryController.clear();
    housing_allowanceController.clear();
    transfer_allowanceController.clear();
    otherController.clear();
    totalController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sumtotal();
    employeeProvider = Provider.of<EmployeeProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("تعديل بيانات الموظف"),
          // trailing: PopupMenuButton<int>(
          //   itemBuilder: (context) => [
          //     PopupMenuItem(

          //       value: 0,
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.delete,
          //             color: Colors.red,
          //           ),
          //           Text("حذف"),
          //         ],
          //       ),
          //     ),
          //   ],
          //   elevation: 2,
          // ),
        ),
        child: employeeProvider.loadinguserprofile
            ? SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "معلومات الموظف",
                          style: headStyle,
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Text(
                          "الاسم",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: namecontroller,
                        ),
                        Text(
                          "رقم الهاتف",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: phonecontroller,
                        ),
                        Text(
                          "رقم الهوية",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: number_idintityController,
                        ),
                        Text(
                          "تاريخ انتهاء الإقامة",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          hint: "تاريخ انتهاء الإقامة",
                          controller: dateController,
                          type: TextInputType.datetime,
                        ),
                        Text(
                          "الراتب الأساسي",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: salaryController,
                        ),
                        Text(
                          "بدل السكن",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: housing_allowanceController,
                        ),
                        Text(
                          "بدل النقل",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: transfer_allowanceController,
                        ),
                        Text(
                          "بدلات أخرى",
                          style: headStyle,
                        ),
                        TextInputForAll(
                          controller: otherController,
                        ),
                        Text(
                          "المجموع",
                          style: headStyle,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextInputForAll(
                                state: false,
                                hint: "المجموع",
                                controller: totalController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoButton(
                                  onPressed: () {
                                    sumtotal();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_circle_outline_outlined),
                                      Text("حساب المجموع")
                                    ],
                                  )),
                            )
                          ],
                        ),
                        Text(
                          "ملاحظة: سيتم احتساب مجموع الراتب إضافة للبدلات تلقائياً عند الضغط على زر حفظ",
                          style: TextStyle(color: Colors.red),
                        ),
                        Row(
                          children: [
                            employeeProvider.loadingedit
                                ? Expanded(
                                    child: Center(
                                        child: CupertinoActivityIndicator()),
                                  )
                                : Expanded(
                                    child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: CupertinoColors.activeBlue,
                                        onPressed: () async {
                                          if (await employeeProvider.EditUser(
                                              name: namecontroller.text,
                                              phone: phonecontroller.text,
                                              userid: widget.userid,
                                              dateTime: dateController.text,
                                              housing_allowance:
                                                  housing_allowanceController
                                                      .text,
                                              number_idintity:
                                                  number_idintityController
                                                      .text,
                                              other: otherController.text,
                                              salary: salaryController.text,
                                              total: totalController.text,
                                              transfer_allowance:
                                                  transfer_allowanceController
                                                      .text)) {
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: HomePageAdmin(),
                                                  isIos: false,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "تم تعديل بيانات الموظف بنجاح")));
                                            await employeeProvider
                                                .getAllUsers();
                                            namecontroller.clear();
                                            phonecontroller.clear();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "حدث خطأ، يرجى إعادة المحاولة")));
                                          }
                                        },
                                        child: Text("حفظ"))),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            employeeProvider.loadingedit
                                ? Expanded(
                                    child: Center(
                                        child: CupertinoActivityIndicator()),
                                  )
                                : Expanded(
                                    child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: CupertinoColors.systemRed,
                                        onPressed: () async {
                                          if (await employeeProvider.deleteUser(
                                              userid: widget.userid)) {
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: HomePageAdmin(),
                                                  isIos: false,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                ));
                                            Flushbar(
                                                    duration:
                                                        Duration(seconds: 3),
                                                    backgroundColor:
                                                        CupertinoColors
                                                            .activeGreen,
                                                    title: "",
                                                    message:
                                                        "تم حذف الموظف بنجاح")
                                                .show(context);
                                            await employeeProvider
                                                .getAllUsers();
                                            namecontroller.clear();
                                            phonecontroller.clear();
                                          } else {
                                            Flushbar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor:
                                                  CupertinoColors.systemRed,
                                              title: "",
                                              message:
                                                  "حدث خطأ يرجى إعادة المحاولة",
                                            ).show(context);
                                          }
                                        },
                                        child: Text("حذف"))),
                          ],
                        ),
                      ]),
                )),
              ));
  }
}
