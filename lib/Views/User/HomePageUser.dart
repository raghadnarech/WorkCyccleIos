import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/MoneyProvider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Admin/employee.dart';
import 'package:qr_app/Views/Admin/generate_qr_code.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/moneyPage.dart';
import 'package:qr_app/Views/User/permissions.dart';
import 'package:qr_app/Views/User/scannerQrCode.dart';
import 'package:qr_app/Views/User/tasksPage.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  void initState() {
    if (taskProvider.listTasks.isEmpty) {
      taskProvider.getMyTask();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    moneyProvider = Provider.of<MoneyProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode_viewfinder),
            label: "قراءة Qr",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_seal_fill),
            label: "المهام",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle_fill),
            label: "مدفوعات",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings_solid),
            label: "الأذونات",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return ScannerQr();
          case 1:
            return TasksPage();
          case 2:
            return MoneyPage();
          case 3:
            return Permissions();
          default:
            return Container();
        }
      },
      backgroundColor: CupertinoColors.white,
      resizeToAvoidBottomInset: false,
    );
  }
}
