// import 'dart:convert';
//
// import 'package:ebooks/data/drawer_items.dart';
// import 'package:ebooks/models/drawer_item.dart';
// import 'package:ebooks/models/get_books_info.dart';
// import 'package:ebooks/models/get_books_info_02.dart';
// import 'package:ebooks/models/get_chapters.dart';
// import 'package:ebooks/models/get_lessons.dart';
// import 'package:ebooks/models/get_parts.dart';
// import 'package:ebooks/pages/nav_pdf.dart';
// import 'package:flutter/material.dart                                              ';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../api/my_api.dart';
// import '../models/get_part.dart';
// import '../models/pdf_tile.dart';
// import '../provider/navigation_provider2.dart';
//
// class NavigationDrawerWidget2 extends StatefulWidget {
//   const NavigationDrawerWidget2({super.key});
//
//   @override
//   State<NavigationDrawerWidget2> createState() =>
//       _NavigationDrawerWidget2State();
// }
//
// class _NavigationDrawerWidget2State extends State<NavigationDrawerWidget2> {
//   final padding = const EdgeInsets.symmetric(horizontal: 20);
//   List<Lessons> lessons = [];
//   var bookId = 0;
//
//   @override
//   void initState() {
//     _checkBookIdStatus();
//     super.initState();
//   }
//
//   _checkBookIdStatus() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var bookid = localStorage.getInt('bookid');
//     if (bookid != null) {
//       setState(() {
//         bookId = bookid;
//       });
//       _fetchParts();
//     }
//   }
//
//   _fetchParts() async {
//     CallApi().getPublicData('bookchapter/$bookId').then(
//       (response) {
//         setState(
//           () {
//             Iterable list = json.decode(response.body);
//             print(list);
//             lessons = list.map((e) => Lessons.fromJson(e)).toList();
//             // if (response.body != null) {
//             //
//             // } else {
//             //   // If that call was not successful, throw an error.
//             //   throw Exception('Failed to load post');
//             // }
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final safeArea =
//         EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
//
//     final provider = Provider.of<NavigationProvider2>(context);
//     final isCollapsed = provider.isCollapsed;
//
//     return SizedBox(
//       width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
//       child: Drawer(
//         child: Container(
//           color: const Color(0xff292735),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 24).add(safeArea),
//                 width: double.infinity,
//                 color: Colors.white12,
//                 child: buildHeader(isCollapsed),
//               ),
//               const SizedBox(height: 24),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: buildTile(isCollapsed: isCollapsed, items: lessons),
//                 ),
//               ),
//               buildCollapseIcon(context, isCollapsed),
//               const SizedBox(height: 12),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTile({
//     required bool isCollapsed,
//     required List<Lessons> items,
//     int indexOffset = 0,
//   }) =>
//       ListView.separated(
//         padding: isCollapsed ? EdgeInsets.zero : padding,
//         shrinkWrap: true,
//         primary: false,
//         itemCount: items.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 16),
//         itemBuilder: (context, index) {
//           final item = items[index];
//
//           return buildMenuItemTiles(
//             isCollapsed: isCollapsed,
//             text: item.title,
//             cat: item.chaptertitle,
//             icon: Icons.folder,
//             path: item.path,
//           );
//         },
//       );
//
//   Widget buildMenuItemTiles({
//     required bool isCollapsed,
//     required String text,
//     required String cat,
//     required IconData icon,
//     required String path,
//   }) {
//     final color = Colors.pink.shade50;
//     final leadingPdf = Icon(Icons.picture_as_pdf, color: color);
//     return Material(
//       color: Colors.transparent,
//       child: isCollapsed
//           ? ListTile(
//               title: leadingPdf,
//               // onTap: onClicked,
//             )
//           : ListTile(
//               onTap: () => onClick(path),
//               leading: leadingPdf,
//               title: Text(
//                 '$cat- $text',
//                 style: TextStyle(color: color, fontSize: 15),
//               ),
//             ),
//     );
//   }
//
//   onClick(path) {
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => MyNav2(
//             path: path,
//             books: Books2(0, '', '', ''),
//           ),
//         ),
//         (Route<dynamic> route) => false);
//     print(path);
//   }
//
//   Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
//     const double size = 52;
//     final icon = isCollapsed
//         ? Icons.arrow_back_ios_new_outlined
//         : Icons.arrow_forward_ios_outlined;
//     final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
//     final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
//     final width = isCollapsed ? double.infinity : size;
//
//     return Container(
//       alignment: alignment,
//       margin: margin,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           child: SizedBox(
//             width: width,
//             height: size,
//             child: Icon(icon, color: Colors.white),
//           ),
//           onTap: () {
//             final provider =
//                 Provider.of<NavigationProvider2>(context, listen: false);
//
//             provider.toggleIsCollapsed2();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget buildHeader(bool isCollapsed) => isCollapsed
//       ? const Image(
//           width: 50,
//           height: 50,
//           image: AssetImage("img/icon.png"),
//         )
//       : const Row(
//           children: [
//             SizedBox(width: 24),
//             Image(
//               width: 50,
//               height: 50,
//               image: AssetImage('img/icon.png'),
//             ),
//             SizedBox(width: 16),
//             Text(
//               'EBook',
//               style: TextStyle(fontSize: 32, color: Colors.white),
//             ),
//           ],
//         );
// }
