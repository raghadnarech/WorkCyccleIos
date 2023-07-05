import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Models/Employee.dart';
import 'package:qr_app/Views/Admin/addEmployee.dart';
import 'package:qr_app/Views/Admin/user_profile.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonCardEmployee.dart';
import 'package:qr_app/Widgets/TextInput.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../../Widgets/ListSkelaton.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

final nameController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final taskcontroller = TextEditingController();

class _EmployeePageState extends State<EmployeePage> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await loadItems();
      },
    );

    super.initState();
  }

  Future loadItems() async {
    await employeeProvider.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    String? text;
    bool repeated = false;
    employeeProvider = Provider.of<EmployeeProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.white,
          middle: Text('الموظفين',
              style: TextStyle(
                  color: CupertinoColors.activeBlue.darkHighContrastColor)),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.logout),
            onPressed: () async {
              authProvider.logout();
              taskProvider.listTasks.clear();
              moneyProvider.listmoney.clear();
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: AuthPage(),
                  isIos: false,
                  duration: Duration(milliseconds: 300),
                ),
              );
            },
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => AddEmployee(),
                                ));
                          },
                          child: Text("إضافة موظف"))
                    ],
                  ),
                  Expanded(
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: employeeProvider.loadinglist
                              ? ListSkelaton(width: width, height: height)
                              : CustomScrollView(
                                  physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  slivers: [
                                      CupertinoSliverRefreshControl(
                                        onRefresh: () async {
                                          await loadItems();
                                        },
                                      ),
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                        childCount: employeeProvider
                                            .listemployee.length,
                                        (context, index) => Slidable(
                                          startActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) async {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child: UserProfile(
                                                          imageuser:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .image,
                                                          userid:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .id,
                                                          name: employeeProvider
                                                              .listemployee[
                                                                  index]
                                                              .name,
                                                          phone:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .phone,
                                                          dateTime:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .dateTime,
                                                          housing_allowance:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .housing_allowance,
                                                          number_idintity:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .number_idintity,
                                                          other:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .other,
                                                          salary:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .salary,
                                                          total:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .total,
                                                          transfer_allowance:
                                                              employeeProvider
                                                                  .listemployee[
                                                                      index]
                                                                  .transfer_allowance,
                                                        ),
                                                        isIos: false,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                      ));
                                                  await employeeProvider
                                                      .getUserProfile(
                                                          employeeProvider
                                                              .listemployee[
                                                                  index]
                                                              .id);
                                                },
                                                backgroundColor:
                                                    Color(0xFF21B7CA),
                                                foregroundColor: Colors.white,
                                                icon: Icons.remove_red_eye,
                                                label: 'عرض',
                                              ),
                                            ],
                                          ),
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showCupertinoDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              StatefulBuilder(
                                                                builder: (context,
                                                                        setState) =>
                                                                    CupertinoAlertDialog(
                                                                  content: Form(
                                                                    key: key,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        TextInputForAll(
                                                                          hint:
                                                                              "المهمة",
                                                                          controller:
                                                                              taskcontroller,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            CupertinoSwitch(
                                                                                value: repeated,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    repeated = value;
                                                                                  });
                                                                                }),
                                                                            Text("مكررة"),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        taskProvider.loadinggivetask
                                                                            ? Expanded(child: Center(child: CupertinoActivityIndicator()))
                                                                            : Expanded(
                                                                                child: CupertinoButton(
                                                                                    child: Text('اسناد المهمة'),
                                                                                    onPressed: () async {
                                                                                      if (key.currentState!.validate()) {
                                                                                        setState(
                                                                                          () {},
                                                                                        );
                                                                                        if (await taskProvider.givetaskforuser(userid: employeeProvider.listemployee[index].id!.toString(), task: taskcontroller.text, repeated: repeated)) {
                                                                                          taskcontroller.clear();

                                                                                          Navigator.pop(context);
                                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم اسناد المهمة للموظف بنجاح")));
                                                                                        } else {
                                                                                          taskcontroller.clear();

                                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ, يرجى إعادة المحاولة")));
                                                                                        }
                                                                                      }
                                                                                    }),
                                                                              ),
                                                                        VerticalDivider(),
                                                                        CupertinoButton(
                                                                          child:
                                                                              Text('خروج'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            taskcontroller.clear();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                },
                                                backgroundColor:
                                                    Color(0xFF21B7CA),
                                                foregroundColor: Colors.white,
                                                icon: Icons.add_task,
                                                label: 'اسناد مهمة',
                                              ),
                                            ],
                                          ),
                                          child: SizedBox(
                                            width: width,
                                            height: height * 0.1,
                                            child: Card(
                                              elevation: 2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${employeeProvider.listemployee[index].name}"),
                                                  Text(
                                                      "${employeeProvider.listemployee[index].phone}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ])))
                ]))));
  }
}
