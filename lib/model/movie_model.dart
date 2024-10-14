class Movie {
  final String title;
  final String description;
  final List<String> genre;
  final int year;
  final bool isrealeased;
  final Director director;
  final List<Actor> actor;

  Movie(
      {required this.title,
      required this.description,
      required this.genre,
      required this.year,
      required this.isrealeased,
      required this.director,
      required this.actor});

  //! convert Firestore document data to Movie (model) object
  // ? fromFirestore is a userdefine function
  factory Movie.fromMovieFirstore(Map<String, dynamic> data) {
    // print("Data received: $data");
    var actorlist = data['actor'] as List<dynamic> ?? [];

    List<Actor> actor = actorlist // Convert to List<Actor>
        .map((actorMap) => Actor.fromActor(actorMap))
        .toList();

    return Movie(
      title: data['title'] ?? '',
      genre: List<String>.from(data['genre']) ?? [],
      description: data['description'] ?? '',
      year: data['year'] ?? 0,
      isrealeased: data['isrealeased'] ?? false,
      director: Director.fromMap(data['director'] ?? {}),
      actor: actor,
    );
  }

  //! Convert Movie object to a Map for FireStoreMap
  Map<String, dynamic> toMovieFirestore() {
    return {
      'title': title,
      'genre': genre,
      'description': description,
      'year': year,
      'isrealeased': isrealeased,
      'director': director.toMap(),
      'actor': actor.map((actordata) => actordata.toActor()).toList(),
    };
  }
}

class Director {
  final String name;
  final int age;

  Director({required this.name, required this.age});

  factory Director.fromMap(Map<String, dynamic> director) {
    return Director(
      name: director['name'] ?? '',
      age: director['age'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }
}

class Actor {
  final String name;
  final String role;
  Actor({required this.name, required this.role});

  factory Actor.fromActor(Map<String, dynamic> actor) {
    return Actor(
      name: actor['name'] ?? '',
      role: actor['role'] ?? '',
    );
  }

  Map<String, dynamic> toActor() {
    return {
      'name': name,
      'role': role,
    };
  }
}
