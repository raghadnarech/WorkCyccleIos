import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/Views/Admin/EditUserProfile.dart';
import 'package:qr_app/Views/Admin/addEmployee.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/User/PersonalPermissions.dart';
import 'package:qr_app/constant/colors.dart';

class TextInputForAll extends StatefulWidget {
  String? hint;
  String? lable;
  TextInputType? type;
  bool? state = true;
  TextEditingController? controller;
  TextInputForAll(
      {this.hint, this.type, this.lable, this.controller, this.state});

  @override
  State<TextInputForAll> createState() => _TextInputForAllState();
}

class _TextInputForAllState extends State<TextInputForAll> {
  @override
  void initState() {
    dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  bool secure = true;

  @override
  Widget build(BuildContext context) {
    dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // void _showdatePicker() {}

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CupertinoTextFormFieldRow(
        placeholder: widget.hint,
        placeholderStyle: TextStyle(color: CupertinoColors.black),
        strutStyle:
            StrutStyle.fromTextStyle(TextStyle(color: CupertinoColors.black)),
        decoration: BoxDecoration(
            color: CupertinoColors.white,
            border: Border.all(
                width: 2, color: CupertinoColors.lightBackgroundGray),
            borderRadius: BorderRadius.circular(5)),
        obscureText: widget.hint == "كلمة المرور" ? secure : false,
        enabled: widget.state,
        prefix: widget.type == TextInputType.datetime
            ? GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                minimumDate: DateTime.now(),
                                maximumDate: DateTime(2024),
                                onDateTimeChanged: (value) {
                                  setState(() {
                                    dateaddemployeeController.text =
                                        "${DateFormat('yyyy-MM-dd').format(value)}";
                                    dateController.text =
                                        "${DateFormat('yyyy-MM-dd').format(value)}";
                                    datepersonalController.text =
                                        "${DateFormat('yyyy-MM-dd').format(value)}";
                                    dateadvancepayment.text =
                                        "${DateFormat('yyyy-MM-dd').format(value)}";
                                  });
                                }),
                          ));
                },
                child: Icon(CupertinoIcons.doc_plaintext))
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return 'حقل مطلوب';
          }
        }),
        controller: widget.controller,
        style: TextStyle(
          color: CupertinoColors.black,
          fontSize: 14,
        ),
        inputFormatters:
            widget.hint == 'رقم الهاتف' || widget.hint == 'رقم الهوية'
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
        keyboardType: widget.type,
      ),
    );
  }
}
