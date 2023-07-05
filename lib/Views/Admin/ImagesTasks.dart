import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:qr_app/constant/url.dart';

class ImagesTasks extends StatefulWidget {
  List<Map> task = [];
  ImagesTasks({required this.task});

  @override
  State<ImagesTasks> createState() => _ImagesTasksState();
}

class _ImagesTasksState extends State<ImagesTasks> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("صور المهمة")),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Card(
                        elevation: 5,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("التاريخ"),
                            ),
                            DataColumn(
                              label: Text("الصورة"),
                            ),
                          ],
                          rows: widget.task
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(e['image_date'])),
                                    DataCell(SizedBox(
                                      width: 50,
                                      child: InstaImageViewer(
                                        child: Image.network(
                                          "$urlImage/${e['image']}",
                                        ),
                                      ),
                                    )),
                                  ]))
                              .toList(),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
