import 'dart:io';

import 'package:ebooks/app_util.dart';
import 'package:ebooks/data/drawer_items.dart';
import 'package:ebooks/models/drawer_item.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/pages/classmate_page.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/pdf_tile.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  late List<FileSystemEntity> files;
  static const pdfTiles = [
    PdfTile(
      title: 'JungleBook',
      lessons: [
        PdfTile(
          title: 'c4611_sample_explain.pdf',
        ),
      ],
    ),
  ];

  var url =
      'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
  @override
  void initState() {
    // _downloadPdf();
    getBooks();
    super.initState();
  }

  getBooks() async {
    files = await AppUtil.readBooks();
  }

  String splitPath(url) {
    File file = File(url);
    String filename = file.path.split(Platform.pathSeparator).last;
    return filename;
  }

  _downloadPdf() async {
    String filename = AppUtil().splitPath(url);
    String newFile = await AppUtil.downloadPdFiles(url, filename, 'JungleBook');
    if (newFile == "success") {
      AppUtil.readFilesDir('JungleBook');
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;
    return SizedBox(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: const Color(0xff292735),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24).add(safeArea),
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
              Expanded(
                child: SingleChildScrollView(
                  child: buildTile(isCollapsed: isCollapsed, items: files),
                ),
              ),
              // const Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile({
    required bool isCollapsed,
    required List<FileSystemEntity> items,
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
            text: splitPath(item.path),
            icon: Icons.folder_zip_sharp,
            // items: item.lessons
            // onClicked: () => selectItem(context, indexOffset + index),
          );
          // return ExpansionTile(
          //   title: Text(item.title),
          //   children: item.lessons.map((e) => Text(e.title)).toList(),
          // );
        },
      );

  Widget buildMenuItemTiles({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    // required List<PdfTile> items,
    VoidCallback? onClicked,
  }) {
    final color = Colors.pink.shade50;
    final color2 = Colors.pink.shade400;
    final leadingPdf = Icon(Icons.picture_as_pdf, color: color2);
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
              title: Theme(
                data: ThemeData(
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  collapsedIconColor: color,
                  title:
                      Text(text, style: TextStyle(color: color, fontSize: 16)),
                  // children: items
                  //     .map((it) => ListTile(
                  //           leading: leadingPdf,
                  //           title: Text(
                  //             it.title,
                  //             style: TextStyle(color: color, fontSize: 16),
                  //           ),
                  //         ))
                  //     .toList(),
                ),
              )),
    );
  }

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
        navigateTo(const Classmate());
        break;
      // case 2:
      //   navigateTo(TestingPage());
      //   break;
      // case 3:
      //   navigateTo(PerformancePage());
      //   break;
      // case 4:
      //   navigateTo(DeploymentPage());
      //   break;
      // case 5:
      //   navigateTo(ResourcesPage());
      //   break;
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
    const double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
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
      ? const Image(
          width: 50,
          height: 50,
          image: AssetImage("img/icon.png"),
        )
      : const Row(
          children: [
            SizedBox(width: 24),
            Image(
              width: 50,
              height: 50,
              image: AssetImage('img/icon.png'),
            ),
            SizedBox(width: 16),
            Text(
              'EBook',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}
