class Course{

     final int id;
     final String name;
     Course({
       required this.id,
       required this.name
     });

     factory Course.fromJson(Map<String,dynamic> json){ // use same memory object / or return if existing object is available
       return Course(
           id: json["id"],
           name: json["name"],
       );
     }

}