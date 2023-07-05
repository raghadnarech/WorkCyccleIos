import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Models/UserPermmision.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/constant/colors.dart';
import 'package:qr_app/constant/url.dart';

class PerDetail extends StatefulWidget {
  PermissionUser? permissionUser;
  PerDetail({this.permissionUser});

  @override
  State<PerDetail> createState() => _PerDetailState();
}

class _PerDetailState extends State<PerDetail> {
  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.white,
          middle: Text('تفاصيل الإذن'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("نوع الإذن:", style: headStyle),
                        Text(
                          "${widget.permissionUser!.kind == "personal" ? "إذن شخصي" : "إذن مرضي"}",
                          style: contentStyle,
                        ),
                        Visibility(
                            visible: widget.permissionUser!.kind == "personal",
                            child: Text("تاريخ الإذن:", style: headStyle)),
                        Visibility(
                            visible: widget.permissionUser!.kind == "personal",
                            child: Text("${widget.permissionUser!.date}",
                                style: contentStyle)),
                        Text("مدة الإذن: ", style: headStyle),
                        Text(
                            "${widget.permissionUser!.kind == "personal" ? "${widget.permissionUser!.houres} ساعات" : "${widget.permissionUser!.days} ايام"}",
                            style: contentStyle),
                        Visibility(
                          visible: widget.permissionUser!.status == 1,
                          child: Text(
                              "تم الموافقة على: ${widget.permissionUser!.kind == "personal" ? "${widget.permissionUser!.houres} ساعات" : "${widget.permissionUser!.days} ايام"}",
                              style: headStyle),
                        ),
                        Visibility(
                            visible: widget.permissionUser!.kind == "personal",
                            child: Text("سبب الإذن:", style: headStyle)),
                        Visibility(
                            visible: widget.permissionUser!.kind == "personal",
                            child: Text("${widget.permissionUser!.reason}",
                                style: contentStyle)),
                        Visibility(
                            visible: widget.permissionUser!.kind != "personal",
                            child: Text("المرفقات:", style: headStyle)),
                        Visibility(
                          visible: widget.permissionUser!.kind != "personal",
                          child: SizedBox(
                              width: width,
                              height: height * 0.3,
                              child: InstaImageViewer(
                                child: Image.network(
                                    "$urlImage/${widget.permissionUser!.image}",
                                    fit: BoxFit.contain),
                              )),
                        ),
                        Divider(),
                        widget.permissionUser!.status == 1
                            ? Center(
                                child: Text(
                                "تم قبول الطلب ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: CupertinoColors.activeGreen),
                              ))
                            : widget.permissionUser!.status == 2
                                ? Center(
                                    child: Text(
                                    "تم رفض الطلب ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: CupertinoColors.systemRed),
                                  ))
                                : Center(
                                    child: Text(
                                    "الطلب قيد الانتظار...",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: CupertinoColors.systemOrange),
                                  ))
                      ]))),
        ));
  }
}
