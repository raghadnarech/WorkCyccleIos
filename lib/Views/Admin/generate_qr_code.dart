import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();
  var dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    var dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('Qr انشاء',
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
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: QrforImage(dateformat),
            ),
          ),
        ],
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'ََQR_Code_$time';
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$name.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  QrforImage(String? data) {
    return Center(
      child: QrImage(
        backgroundColor: Colors.white,
        data: data!,
        size: 280,
        // You can include embeddedImageStyle Property if you
        //wanna embed an image from your Asset folder
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(
            100,
            100,
          ),
        ),
      ),
    );
  }
}
