import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Models/Employee.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/SkelatonCardEmployee.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class Gift_DiscPage extends StatefulWidget {
  const Gift_DiscPage({super.key});

  @override
  State<Gift_DiscPage> createState() => _Gift_DiscPageState();
}

final key = GlobalKey<FormState>();

final deductionController = TextEditingController();
final dateadvancepayment = TextEditingController();
final addController = TextEditingController();
final reasonController = TextEditingController();

class _Gift_DiscPageState extends State<Gift_DiscPage> {
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

  String? text;
  Future loadItems() async {
    await employeeProvider.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    moneyProvider = Provider.of<MoneyProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // String Selectemploye = "الموظف 1";
    // List<String> employees = ["الموظف 3", "الموظف 2", "الموظف 1"];
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('مدفوعات',
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
              Expanded(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: employeeProvider.loadinglist
                      ? ListView.builder(
                          itemBuilder: (context, index) => SkelatonCardEmployee(
                              width: width, height: height),
                          itemCount: 7,
                        )
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
                                    childCount:
                                        employeeProvider.listemployee.length,
                                    (context, index) => Slidable(
                                          startActionPane: ActionPane(
                                              motion: ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            CupertinoAlertDialog(
                                                          content: Form(
                                                            key: key,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                TextInputForAll(
                                                                  hint:
                                                                      "السلفة",
                                                                  controller:
                                                                      deductionController,
                                                                ),
                                                                TextInputForAll(
                                                                  hint:
                                                                      "تاريخ السلفة",
                                                                  controller:
                                                                      dateadvancepayment,
                                                                  type: TextInputType
                                                                      .datetime,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            Row(
                                                              children: [
                                                                moneyProvider
                                                                        .isloadinggiveMoney
                                                                    ? Expanded(
                                                                        child: Center(
                                                                            child:
                                                                                CupertinoActivityIndicator()))
                                                                    : Expanded(
                                                                        child:
                                                                            CupertinoButton(
                                                                          child:
                                                                              Text("موافق"),
                                                                          onPressed:
                                                                              () async {
                                                                            if (key.currentState!.validate()) {
                                                                              setState(
                                                                                () {},
                                                                              );
                                                                              if (await moneyProvider.giveMoneyforUserAdvance(amount: deductionController.text, amount_status: "Advance payment", userId: employeeProvider.listemployee[index].id.toString(), date: dateadvancepayment.text)) {
                                                                                Navigator.pop(context);
                                                                                deductionController.clear();
                                                                                reasonController.clear();
                                                                                dateadvancepayment.clear();
                                                                                Flushbar(
                                                                                  duration: Duration(seconds: 3),
                                                                                  backgroundColor: CupertinoColors.activeGreen,
                                                                                  title: "",
                                                                                  message: "تم اسناد السلفة بنجاح",
                                                                                ).show(context);
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                                deductionController.clear();
                                                                                reasonController.clear();
                                                                                dateadvancepayment.clear();
                                                                                Flushbar(
                                                                                  duration: Duration(seconds: 3),
                                                                                  backgroundColor: CupertinoColors.systemRed,
                                                                                  title: "",
                                                                                  message: "حدث خطأ يرجى إعادة المحاولة",
                                                                                ).show(context);
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                VerticalDivider(),
                                                                CupertinoButton(
                                                                  child: Text(
                                                                      'خروج'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    deductionController
                                                                        .clear();
                                                                    reasonController
                                                                        .clear();
                                                                    dateadvancepayment
                                                                        .clear();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  backgroundColor:
                                                      Color(0xFF21B7CA),
                                                  foregroundColor:
                                                      CupertinoColors.white,
                                                  icon:
                                                      Icons.handshake_outlined,
                                                  label: 'سلفة',
                                                ),
                                              ]),
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        StatefulBuilder(
                                                      builder: (context,
                                                              setState) =>
                                                          CupertinoAlertDialog(
                                                        content: Form(
                                                          key: key,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextInputForAll(
                                                                hint:
                                                                    "المكافأة",
                                                                controller:
                                                                    addController,
                                                              ),
                                                              TextInputForAll(
                                                                hint: "السبب",
                                                                controller:
                                                                    reasonController,
                                                              ),
                                                              TextInputForAll(
                                                                hint:
                                                                    "تاريخ المكافأة",
                                                                controller:
                                                                    dateadvancepayment,
                                                                type: TextInputType
                                                                    .datetime,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              moneyProvider
                                                                      .isloadinggiveMoney
                                                                  ? Expanded(
                                                                      child: Center(
                                                                          child:
                                                                              CupertinoActivityIndicator()))
                                                                  : Expanded(
                                                                      child:
                                                                          CupertinoButton(
                                                                        child: Text(
                                                                            "موافق"),
                                                                        onPressed:
                                                                            () async {
                                                                          if (key
                                                                              .currentState!
                                                                              .validate()) {
                                                                            setState(
                                                                              () {},
                                                                            );
                                                                            if (await moneyProvider.giveMoneyforUser(
                                                                                amount: addController.text,
                                                                                amount_status: "add",
                                                                                date: dateadvancepayment.text,
                                                                                userId: employeeProvider.listemployee[index].id.toString(),
                                                                                reason: reasonController.text)) {
                                                                              Navigator.pop(context);
                                                                              addController.clear();
                                                                              reasonController.clear();
                                                                              dateadvancepayment.clear();
                                                                              Flushbar(
                                                                                duration: Duration(seconds: 3),
                                                                                backgroundColor: CupertinoColors.activeGreen,
                                                                                title: "",
                                                                                message: "تم اسناد المكافأة بنجاح",
                                                                              ).show(context);
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              addController.clear();
                                                                              reasonController.clear();
                                                                              dateadvancepayment.clear();
                                                                              Flushbar(
                                                                                duration: Duration(seconds: 3),
                                                                                backgroundColor: CupertinoColors.systemRed,
                                                                                title: "",
                                                                                message: "حدث خطأ يرجى إعادة المحاولة",
                                                                              ).show(context);
                                                                            }
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                              VerticalDivider(),
                                                              CupertinoButton(
                                                                child: Text(
                                                                    'خروج'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  addController
                                                                      .clear();
                                                                  reasonController
                                                                      .clear();
                                                                  dateadvancepayment
                                                                      .clear();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                backgroundColor:
                                                    CupertinoColors.activeGreen,
                                                foregroundColor:
                                                    CupertinoColors.white,
                                                icon:
                                                    CupertinoIcons.money_dollar,
                                                label: 'مكافأة',
                                              ),
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        StatefulBuilder(
                                                      builder: (context,
                                                              setState) =>
                                                          CupertinoAlertDialog(
                                                        content: Form(
                                                          key: key,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextInputForAll(
                                                                hint: "الخصم",
                                                                controller:
                                                                    deductionController,
                                                              ),
                                                              TextInputForAll(
                                                                hint: "السبب",
                                                                controller:
                                                                    reasonController,
                                                              ),
                                                              TextInputForAll(
                                                                hint:
                                                                    "تاريخ الخصم",
                                                                controller:
                                                                    dateadvancepayment,
                                                                type: TextInputType
                                                                    .datetime,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              moneyProvider
                                                                      .isloadinggiveMoney
                                                                  ? Expanded(
                                                                      child: Center(
                                                                          child:
                                                                              CupertinoActivityIndicator()))
                                                                  : Expanded(
                                                                      child:
                                                                          CupertinoButton(
                                                                        child: Text(
                                                                            "موافق"),
                                                                        onPressed:
                                                                            () async {
                                                                          if (key
                                                                              .currentState!
                                                                              .validate()) {
                                                                            setState(
                                                                              () {},
                                                                            );
                                                                            if (await moneyProvider.giveMoneyforUser(
                                                                                amount: deductionController.text,
                                                                                amount_status: "deduction",
                                                                                userId: employeeProvider.listemployee[index].id.toString(),
                                                                                date: dateadvancepayment.text,
                                                                                reason: reasonController.text)) {
                                                                              Navigator.pop(context);
                                                                              deductionController.clear();
                                                                              reasonController.clear();
                                                                              dateadvancepayment.clear();
                                                                              Flushbar(
                                                                                backgroundColor: CupertinoColors.activeGreen,
                                                                                message: "تم اسناد الخصم بنجاح",
                                                                                title: "",
                                                                              ).show(context);
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              deductionController.clear();
                                                                              reasonController.clear();
                                                                              dateadvancepayment.clear();
                                                                              Flushbar(
                                                                                backgroundColor: CupertinoColors.systemRed,
                                                                                message: "حدث خطأ يرجى إعادة المحاولة",
                                                                                title: "",
                                                                              ).show(context);
                                                                            }
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                              VerticalDivider(),
                                                              CupertinoButton(
                                                                child: Text(
                                                                    'خروج'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  deductionController
                                                                      .clear();
                                                                  reasonController
                                                                      .clear();
                                                                  dateadvancepayment
                                                                      .clear();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                backgroundColor:
                                                    Color(0xFFFE4A49),
                                                foregroundColor:
                                                    CupertinoColors.white,
                                                icon:
                                                    CupertinoIcons.money_dollar,
                                                label: 'خصم',
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
                                        ))),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
