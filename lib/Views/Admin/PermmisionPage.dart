import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_app/Views/Admin/acceptPermmision.dart';
import 'package:qr_app/Views/Admin/rejectPermmision.dart';
import 'package:qr_app/Views/Admin/waitPermission.dart';
import 'package:qr_app/Views/Splash/splash.dart';

class PermmisionPage extends StatefulWidget {
  const PermmisionPage({super.key});

  @override
  State<PermmisionPage> createState() => _PermmisionPageState();
}

class _PermmisionPageState extends State<PermmisionPage> {
  @override
  void initState() {
    permissionsProvider.getAllPermmision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_sharp),
            label: "قيد الانتظار",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel_outlined),
            label: "مرفوضة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "مقبولة",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return WaitPermm();
          case 1:
            return RejPermm();
          case 2:
            return AccPermm();

          default:
            return Container();
        }
      },
      backgroundColor: CupertinoColors.white,
      resizeToAvoidBottomInset: false,
    );
  }
}
