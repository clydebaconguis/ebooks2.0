import 'dart:convert';

import 'package:ebooks/data/drawer_items.dart';
import 'package:ebooks/models/drawer_item.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:ebooks/pages/profile_page.dart';
import 'package:ebooks/pages/settings.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/signup_login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pdf_tile.dart';
import '../user/user.dart';
import '../user/user_data.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  late List<PdfTile> files = [];
  var user = UserData.myUser;
  String grade = '';

  @override
  void initState() {
    // getDownloadedBooks();
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');
    grade = preferences.getString('grade')!;

    setState(() {
      user = json == null ? UserData.myUser : User.fromJson(jsonDecode(json));
    });
  }

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
    // EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    var isCollapsed = provider.isCollapsed;

    return SizedBox(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffcf167f), Color(0xff500a34)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          // color: const Color(0xff292735),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 24),
              buildList(items: itemsFirst, isCollapsed: isCollapsed),
              const SizedBox(height: 24),
              const Divider(
                color: Colors.white24,
              ),
              buildProfileCircle(isCollapsed),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.white24,
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              buildLogout(items: itemsFirst2, isCollapsed: isCollapsed),
              const SizedBox(height: 30),
              !isCollapsed
                  ? Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.copyright_outlined,
                              color: Colors.white38,
                              size: 18.0,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Copyright 2023',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Powered by',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "img/cklogo.png",
                                height: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            buildCollapseIcon(context, isCollapsed),
                          ],
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "img/cklogo.png",
                        height: 25,
                      ),
                    ),
              isCollapsed
                  ? buildCollapseIcon(context, isCollapsed)
                  : const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  onClick(path) {
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => MyNav2(
    //         path: path,
    //         books: PdfTile(),
    //       ),
    //     ),
    //     (Route<dynamic> route) => false);
    // print(path);
  }

  // Pdf Tile
  Widget buildTile({
    required bool isCollapsed,
    required List<PdfTile> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItemTiles(
            isCollapsed: isCollapsed,
            text: item.title,
            path: item.path,
            icon: Icons.picture_as_pdf_outlined,
            // items: item.lessons,
          );
        },
      );

  Widget buildMenuItemTiles({
    required bool isCollapsed,
    required String text,
    required String path,
    required IconData icon,
    // required List<PdfTile> items,
    VoidCallback? onClicked,
  }) {
    final color = Colors.pink.shade50;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              // onTap: onClicked,
            )
          : ListTile(
              minLeadingWidth: 0,
              leading: leading,
              title: Text(
                text,
                style: TextStyle(color: color),
              ),
              // title: ExpansionTile(
              //   collapsedIconColor: color,
              //   title: Text(
              //     text,
              //     style: TextStyle(color: color, fontSize: 16),
              //     overflow: TextOverflow.ellipsis,
              //     maxLines: 2,
              //     softWrap: true,
              //   ),
              //   children: items
              //       .map((it) => ListTile(
              //             onTap: () => onClick(it.path),
              //             minVerticalPadding: 0,
              //             horizontalTitleGap: 0,
              //             leading: leadingPdf,
              //             title: Text(
              //               it.title,
              //               style: TextStyle(color: color, fontSize: 16),
              //             ),
              //           ))
              //       .toList(),
              // ),
            ),
    );
  }

  // Main Nav tile
  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    navigateTo(page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(const MyNav());
        break;
      case 1:
        navigateTo(const ProfilePage());
        break;
      case 2:
        navigateTo(const Setting());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text,
                  style: const TextStyle(color: color, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    const double size = 30;
    final icon = isCollapsed
        ? Icons.arrow_forward_ios_rounded
        : Icons.arrow_back_ios_rounded;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    // final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      // margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(
              icon,
              color: const Color(0xE7E91E63),
              size: 20,
            ),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? Container(
          padding: const EdgeInsets.only(bottom: 22, top: 22),
          child: const Image(
            width: 50,
            height: 50,
            image: AssetImage("img/liceo-logo.png"),
          ),
        )
      : Container(
          padding: const EdgeInsets.only(bottom: 22, top: 22),
          child: Row(
            children: [
              const SizedBox(width: 24),
              const Image(
                width: 50,
                height: 50,
                image: AssetImage("img/liceo-logo.png"),
              ),
              const SizedBox(width: 16),
              Text(
                'EBook',
                style: GoogleFonts.prompt(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30),
                ),
              ),
            ],
          ),
        );

  Widget buildLogout({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () {
              // EasyLoading.show(status: 'Signing out...');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              );
              logout();
            },
          );
        },
      );

  Widget buildProfileCircle(bool isCollapsed) => isCollapsed
      ? const Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFD5F6FF),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFD5F6FF),
                    backgroundImage: AssetImage("img/anonymous.jpg"),
                    radius: 30,
                  ),
                ),
                // Positioned(
                //   left: 1,
                //   bottom: -1,
                //   child: buildEditIcon(const Color(0xE70DDA11), 20, 1),
                // )
              ],
            ),
          ],
        )
      : Column(
          children: [
            const SizedBox(height: 24),
            const Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Color(0xFFD5F6FF),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFD5F6FF),
                    backgroundImage: AssetImage("img/anonymous.jpg"),
                    radius: 60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              child: Text(
                user.name.toUpperCase(),
                style: GoogleFonts.prompt(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              grade,
              style: GoogleFonts.prompt(
                textStyle: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            // Text(
            //   grade,
            //   style: const TextStyle(
            //       fontWeight: FontWeight.bold, color: Colors.greenAccent),
            // ),
          ],
        );

  Widget buildEditIcon(Color color, double size, double pad) => buildCircle(
      all: pad,
      child: Icon(
        Icons.safety_check,
        color: color,
        size: size,
      ));

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        // color: const Color(0xFFE91E63),
        child: child,
      ));
}
