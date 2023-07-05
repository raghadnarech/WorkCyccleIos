import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/TaskProvider.dart';
import 'package:qr_app/Views/Splash/splash.dart';

class EndTaskPage extends StatefulWidget {
  int? taskid;
  String? status;
  EndTaskPage({this.taskid, this.status});

  @override
  State<EndTaskPage> createState() => _EndTaskPageState();
}

class _EndTaskPageState extends State<EndTaskPage> {
  final ImagePickerIOS _picker = ImagePickerIOS();
  String? imageName = "";
  File? imagePath;
  File? file;
  XFile? imagefilesx;

  openImagefromGalary() async {
    var pickedfiles = await _picker.getImage(source: ImageSource.gallery);
    //you can use ImageCourse.camera for Camera capture
    if (pickedfiles != null) {
      setState(() {
        imagefilesx = pickedfiles;
      });
    }
  }

  openImagefromCamer() async {
    var pickedfiles = await _picker.getImage(source: ImageSource.camera);
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

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("صفحة انهاء المهمة"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                                    "يرجى ارفاق صورة تثبت أن المهمة قد انجزت")),
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
                              Text("اختيار من المعرض"),
                              Icon(Icons.image),
                            ],
                          )),
                      CupertinoButton(
                          onPressed: () {
                            openImagefromCamer();
                          },
                          child: Row(
                            children: [
                              Text("فتح الكاميرا"),
                              Icon(Icons.camera),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                    width: width * 0.5,
                    height: height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        color: CupertinoColors.activeGreen,
                        onPressed: () async {
                          if (imagefilesx != null) {
                            imagePath = File(imagefilesx!.path);
                            if (await taskProvider.taskfinished(
                                image: imagePath,
                                taskid: widget.taskid,
                                repeated: widget.status)) {
                              Navigator.pop(context);
                              Flushbar(
                                duration: Duration(seconds: 3),
                                backgroundColor: CupertinoColors.activeGreen,
                                title: "",
                                message: "تم انهاء المهمة بنجاح",
                              ).show(context);
                            }
                          } else {
                            Flushbar(
                              duration: Duration(seconds: 3),
                              backgroundColor: CupertinoColors.systemRed,
                              title: "تعذر انهاء المهمة",
                              message: "لايمكن انهاء المهمة قبل ارفاق صورة",
                            ).show(context);
                          }
                        },
                        child: taskProvider.loadingfinish
                            ? CupertinoActivityIndicator()
                            : Center(child: Text("تأكيد")),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
