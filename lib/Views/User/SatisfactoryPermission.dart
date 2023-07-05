import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Widgets/TextInput.dart';

class SatisfactoryPermission extends StatefulWidget {
  const SatisfactoryPermission({super.key});

  @override
  State<SatisfactoryPermission> createState() => _SatisfactoryPermissionState();
}

final key = GlobalKey<FormState>();

class _SatisfactoryPermissionState extends State<SatisfactoryPermission> {
  final daysController = TextEditingController();
  ImagePickerIOS picker = ImagePickerIOS();
  String? imageName = "";
  File? imagePath;
  File? file;
  XFile? imagefilesx;
  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    openImagefromGalary() async {
      var pickedfiles = await picker.getImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        setState(() {
          imagefilesx = pickedfiles;
        });
      }
    }

    openImagefromCamer() async {
      var pickedfiles = await picker.getImage(source: ImageSource.camera);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        setState(() {
          imagefilesx = pickedfiles;
        });
      }
    }

    clearPhoto() async {
      setState(() {
        imagefilesx = null;
      });
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('طلب إذن مرضي',
            style: TextStyle(
                color: CupertinoColors.activeBlue.darkHighContrastColor)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: height * 0.5,
                      width: width * 0.9,
                      child: imagefilesx == null
                          ? Card(
                              elevation: 5,
                              child: Center(
                                  child: Text(
                                      "يرجى ارفاق صورة تثبت صحة طلب الإذن المرضي ")),
                            )
                          : Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: CupertinoColors.black,
                                            width: 1,
                                            style: BorderStyle.solid)),
                                    child: InstaImageViewer(
                                      child: Image.file(File(imagefilesx!.path),
                                          fit: BoxFit.contain),
                                    )),
                              ),
                            ),
                    ),
                  ),
                  imagefilesx == null
                      ? SizedBox()
                      : SizedBox(
                          width: width * 0.9,
                          child: CupertinoButton(
                              color: CupertinoColors.systemRed,
                              onPressed: () {
                                clearPhoto();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("حذف الصورة"),
                                  Icon(Icons.delete),
                                ],
                              )),
                        ),
                  Divider(),
                  SizedBox(
                    width: width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                            onPressed: () {
                              openImagefromGalary();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.image),
                                Text("اختيار من المعرض"),
                              ],
                            )),
                        CupertinoButton(
                            onPressed: () {
                              openImagefromCamer();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.camera),
                                Text("فتح الكاميرا"),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Divider(),
                  TextInputForAll(
                    lable: "عدد الأيام",
                    hint: "عدد الأيام",
                    controller: daysController,
                    type: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                  ),
                  permissionsProvider.loadingsendSatisf
                      ? SizedBox(
                          width: width * 0.5,
                          height: height * 0.1,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          width: width * 0.5,
                          height: height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoButton(
                              color: CupertinoColors.activeGreen,
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  if (imagefilesx != null) {
                                    imagePath = File(imagefilesx!.path);
                                    if (await permissionsProvider
                                        .SatisfactoryPermissionSent(
                                            image: imagePath,
                                            days: daysController.text)) {
                                      Navigator.pop(context);
                                      Flushbar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor:
                                            CupertinoColors.activeGreen,
                                        title: "تعذر طلب الإذن",
                                        message: "تم طلب الإذن بنجاح",
                                      ).show(context);
                                    } else {
                                      Flushbar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor:
                                            CupertinoColors.systemRed,
                                        title: "تعذر طلب الإذن",
                                        message: "حدث خطأ, يرجى إعادة المحاولة",
                                      ).show(context);
                                    }
                                  } else {
                                    Flushbar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor:
                                          CupertinoColors.systemRed,
                                      title: "تعذر طلب الإذن",
                                      message: "لايمكن طلب إذن قبل ارفاق صورة",
                                    ).show(context);
                                  }
                                } else {
                                  Flushbar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: CupertinoColors.systemRed,
                                    title: "تعذر طلب الإذن",
                                    message:
                                        "لايمكن طلب إذن قبل تحديد عدد الأيام",
                                  ).show(context);
                                }
                              },
                              child: Center(child: Text("تأكيد")),
                            ),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
