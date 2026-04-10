class Modules {
      final int id ;
      final String title;

      Modules({required this.id, required this.title});

      factory Modules.fromJson(Map<String, dynamic> json) {
        return Modules(
          id: json['id'],
          title: json['title'],
        );
      }
}