import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/AuthProvider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Admin/PermmisionPage.dart';
import 'package:qr_app/Views/Admin/employee.dart';
import 'package:qr_app/Views/Admin/generate_qr_code.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/scannerQrCode.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  void initState() {
    if (employeeProvider.listemployee.isEmpty) {
      employeeProvider.getAllUsers();
    }
    if (permissionsProvider.listpermmision.isEmpty) {
      permissionsProvider.getAllPermmision();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.08,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode_viewfinder),
            label: "انشاء Qr",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3_fill),
            label: "الموظفين",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle_fill),
            label: "مدفوعات",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              badgeContent: Text(
                "${permissionsProvider.countwait}",
                style: TextStyle(fontSize: 12, color: CupertinoColors.white),
              ),
              child: Icon(CupertinoIcons.settings_solid),
            ),
            label: "الإذونات",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return GenerateQRCode();
          case 1:
            return EmployeePage();
          case 2:
            return Gift_DiscPage();
          case 3:
            return PermmisionPage();
          default:
            return Container();
        }
      },
    );
  }
}
