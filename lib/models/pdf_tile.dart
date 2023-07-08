class PdfTile {
  final String title;
  final String path;
  final List<PdfTile> children;

  const PdfTile({
    required this.title,
    required this.path,
    this.children = const [],
  });
}
