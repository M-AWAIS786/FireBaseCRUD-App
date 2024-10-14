import 'package:crud_firebase/database/fs_database.dart';
import 'package:crud_firebase/model/movie_model.dart';
import 'package:crud_firebase/screens/filterscreenhome.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String genre = 'Action';
  String description = '';
  int year = 0;
  bool isrealeasd = false;
  FsDatabase fs = FsDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const FilterScreenHome();
          }));
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child:
            const Icon(Icons.next_plan_outlined, size: 32, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    onSaved: (value) => title = value!,
                  ),
                  // TextFormField(
                  //   decoration: const InputDecoration(labelText: "Genre"),
                  //   onSaved: (value) => genre = value!,
                  // ),
                  DropdownButtonFormField(
                    value: genre,
                    items: const [
                      DropdownMenuItem(
                        value: 'Action',
                        child: Text('Action'),
                      ),
                      DropdownMenuItem(
                        value: 'Sci-Fi',
                        child: Text('Sci-Fi'),
                      ),
                    ],
                    onChanged: (value) {
                      genre = value.toString();
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    onSaved: (value) => description = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Year"),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => year = int.parse(value!),
                  ),
                  SwitchListTile(
                    title: const Text('Is Released'),
                    value: isrealeasd,
                    onChanged: (value) {
                      setState(() {
                        isrealeasd = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.save();
                      final movie = Movie(
                        title: title,
                        description: description,
                        genre: [genre],
                        year: year,
                        isrealeased: isrealeasd,
                        director: Director(name: title, age: year),
                        actor: [Actor(name: title, role: description)],
                      );
                      await fs.addMovies(movie);
                    },
                    child: const Text("Add Movie"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.save();
                        final movie = Movie(
                          title: title,
                          description: description,
                          genre: [genre],
                          year: year,
                          isrealeased: isrealeasd,
                          director: Director(name: title, age: year),
                          actor: [Actor(name: title, role: description)],
                        );
                        await fs.updateMovies(movie);
                      },
                      child: const Text("Update Movie")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await fs.deleteMovies();
                      },
                      child: const Text("Delete Movie")),
                ],
              ),
            ),
            StreamBuilder(
                stream: fs.getMoviesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('eerr'),
                    );
                  }
                  // ? snapshotdata instance pass to movie to use in a listview
                  final movies = snapshot.data;
                  if (movies!.isEmpty) {
                    return const Center(
                      child: Text('No data'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      // movies[index];
                      final genrelistdata = movies[index]
                          .genre
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .split(',')
                          .join(' ');
                  final actorslength = movies[index].actor.length;
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movies[index].title),
                            Text(
                                '${movies[index].year} - $genrelistdata - ${movies[index].isrealeased} - ${movies[index].director.name} - ${movies[index].director.age}'),
                            Text(movies[index].description),
                            Text(movies[index].actor[actorslength - 1].name),
                            Text(movies[index].actor[actorslength - 1].role),
                          ],
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
