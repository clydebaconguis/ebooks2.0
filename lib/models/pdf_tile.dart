import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfTile {
  final String title;
  final List<PdfTile> lessons;

  const PdfTile({
    required this.title,
    this.lessons = const [],
  });
}
