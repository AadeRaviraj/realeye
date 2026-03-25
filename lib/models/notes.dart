class Notes {
  final String content;
  final String pdfUrl;
  final String codeExample;

  Notes({
    required this.content,
    required this.pdfUrl,
    required this.codeExample,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      content: json['content'],
      pdfUrl: json['pdfUrl'] ?? "",
      codeExample: json['codeExample'] ?? "",
    );
  }
}