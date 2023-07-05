import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/Controllers/PermissionsProvider.dart';
import 'package:qr_app/Models/Permissions.dart';
import 'package:qr_app/Models/UserPermmision.dart';
import 'package:qr_app/Views/Auth/auth_page.dart';
import 'package:qr_app/Views/Splash/splash.dart';
import 'package:qr_app/Views/User/PerDetailPage.dart';
import 'package:qr_app/Views/User/PersonalPermissions.dart';
import 'package:qr_app/Views/User/SatisfactoryPermission.dart';
import 'package:qr_app/Widgets/ListSkelaton.dart';

class Permissions extends StatefulWidget {
  const Permissions({super.key});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<PermissionUser> _listItems = [];
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await loadItems();
      },
    );

    super.initState();
  }

  Future loadItems() async {
    await permissionsProvider.getMyPer();
    _listItems = [];
    var future = Future(() {});
    for (var i = 0; i < permissionsProvider.listpermmisionuser.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          _listItems.add(permissionsProvider.listpermmisionuser[i]);
          _listKey.currentState!.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    permissionsProvider = Provider.of<PermissionsProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('الإذونات',
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
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: CupertinoColors.systemBlue.darkColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SatisfactoryPermission(),
                              ));
                        },
                        child: Text("إذن مرضي")),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: CupertinoColors.systemBlue.darkColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PersonalPermissions(),
                              ));
                        },
                        child: Text("إذن شخصي")),
                  ),
                ],
              ),
              Expanded(
                  child: SizedBox(
                height: height,
                width: width,
                child: permissionsProvider.listpermmisionuser.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("لايوجد إذونات لديك"),
                            ],
                          ),
                        ],
                      )
                    : permissionsProvider.loadinggetper
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ListSkelaton(width: width, height: height),
                          )
                        : AnimatedList(
                            key: _listKey,
                            initialItemCount: _listItems.length,
                            itemBuilder: (context, index, animation) {
                              return SlideTransition(
                                  position: CurvedAnimation(
                                    curve: Curves.easeOut,
                                    parent: animation,
                                  ).drive((Tween<Offset>(
                                    begin: Offset(1, 0),
                                    end: Offset(0, 0),
                                  ))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: SizedBox(
                                      width: width,
                                      height: height * 0.1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => PerDetail(
                                                    permissionUser:
                                                        _listItems[index]),
                                              ));
                                        },
                                        child: Card(
                                          elevation: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Center(
                                                        child: AutoSizeText(
                                                            "${_listItems[index].kind == "personal" ? "شخصي" : "مرضي"}"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
