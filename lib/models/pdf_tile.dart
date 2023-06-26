import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfTile {
  final String title;
  final String path;
  final List<PdfTile> lessons;

  const PdfTile({
    required this.title,
    required this.path,
    this.lessons = const [],
  });
}
