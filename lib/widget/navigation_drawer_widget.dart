import 'package:ebooks/data/drawer_items.dart';
import 'package:ebooks/models/drawer_item.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/pages/classmate_page.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pdf_tile.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    const pdfTiles = [
      PdfTile(
        title: 'Chapter 1',
        lessons: [
          PdfTile(
            title: 'Lesson 1',
          ),
          PdfTile(
            title: 'Lesson 2',
          ),
          PdfTile(
            title: 'Lesson 3',
          ),
        ],
      ),
      PdfTile(
        title: 'Chapter 2',
        lessons: [
          PdfTile(
            title: 'Lesson 1',
          ),
          PdfTile(
            title: 'Lesson 2',
          ),
          PdfTile(
            title: 'Lesson 3',
          ),
        ],
      ),
    ];

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
              const Spacer(),
              const SizedBox(height: 24),
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: buildTile(isCollapsed: isCollapsed, items: pdfTiles),
              //   ),
              // ),
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
              icon: Icons.folder,
              items: item.lessons
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
    required List<PdfTile> items,
    VoidCallback? onClicked,
  }) {
    const color = Colors.yellow;
    const color2 = Colors.orange;
    final leading = Icon(icon, color: color);
    final leading2 = Icon(icon, color: color2);

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
                  title: Text(text,
                      style: const TextStyle(color: color, fontSize: 16)),
                  children: items
                      .map((it) => ListTile(
                            leading: leading2,
                            title: Text(
                              it.title,
                              style:
                                  const TextStyle(color: color2, fontSize: 16),
                            ),
                          ))
                      .toList(),
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
