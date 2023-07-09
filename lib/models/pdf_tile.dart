class PdfTile {
  final String title;
  final String path;
  final List<PdfTile> children;
  bool isExpanded = true;

  PdfTile({
    required this.title,
    required this.path,
    this.children = const [],
    required this.isExpanded,
  });
}
