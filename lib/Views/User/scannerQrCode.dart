import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/EmployeeProvider.dart';
import 'package:qr_app/Controllers/WorkTimeProvider.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/workTime.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key});

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  String? text = "";
  String? city;
  String? slot;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    employeeProvider = Provider.of<EmployeeProvider>(context);
    workTimeProvider = Provider.of<WorkTimeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.white,
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
            middle: Text('Qr قراءة',
                style: TextStyle(
                    color: CupertinoColors.activeBlue.darkHighContrastColor)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: MobileScanner(
                            fit: BoxFit.fill,
                            controller: MobileScannerController(
                                facing: CameraFacing.back, torchEnabled: false),
                            onDetect: (barcodes) async {
                              await [Permission.camera].request();
                              if (barcodes.raw == null) {
                                debugPrint('Failed to scan Barcode');
                              } else {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) =>
                                      CupertinoAlertDialog(actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CupertinoButton(
                                            onPressed: () async {
                                              if (await employeeProvider
                                                  .takeEnterTime(
                                                      barcodes.raw)) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "تم تسجيل وقت بداية الدوام بنجاح")));
                                              } else {
                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "تم تسجيل وقت بداية الدوام مسبقاً")));
                                              }
                                            },
                                            child: Text("بداية الدوام")),
                                        CupertinoButton(
                                            onPressed: () async {
                                              if (await employeeProvider
                                                  .takeOutTime(barcodes.raw)) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "تم تسجيل وقت نهاية الدوام بنجاح")));
                                              } else {
                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "تم تسجيل وقت نهاية الدوام مسبقاً")));
                                              }
                                            },
                                            child: Text("نهاية الدوام")),
                                      ],
                                    ),
                                  ]),
                                );
                              }
                            },
                          ),
                        ),
                        Divider(),
                        CupertinoButton(
                            padding: EdgeInsets.all(15),
                            color: Color.fromARGB(255, 48, 130, 218),
                            onPressed: () async {
                              workTimeProvider.getMytime();

                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => WorkTime(),
                                  ));
                            },
                            child: Text("جدول الدوام"))
                      ],
                    ),
                  ],
                ),
              ),
              Text(text!)
            ],
          )),
    );
  }
}
