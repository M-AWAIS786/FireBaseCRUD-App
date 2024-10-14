import 'package:crud_firebase/database/fs_database.dart';
import 'package:flutter/material.dart';

class FilterScreenHome extends StatefulWidget {
  const FilterScreenHome({super.key});

  @override
  State<FilterScreenHome> createState() => _FilterScreenHomeState();
}

class _FilterScreenHomeState extends State<FilterScreenHome> {
  FsDatabase fs = FsDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder(
            stream: fs.getFiltermovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('errorrr snapshot'),
                );
              }
              final filterdata = snapshot.data;
              if (filterdata!.isEmpty) {
                return const Center(
                  child: Text('no data'),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: filterdata.length,
                  itemBuilder: (context, index) {
                    final genrelistdata = filterdata[index]
                        .genre
                        .map((e) => e
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''))
                        .join(', ');

                    final director = filterdata[index].director;

                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filterdata[index].title),
                          Text(
                              '${filterdata[index].year} - $genrelistdata - ${filterdata[index].isrealeased} - ${filterdata[index].director.name} - ${filterdata[index].director.age}'),
                          Text(filterdata[index].description),
                          Text(filterdata[index].actor[index].name),
                          Text(filterdata[index].actor[index].role),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
