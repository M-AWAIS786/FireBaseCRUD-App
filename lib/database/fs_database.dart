import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/model/movie_model.dart';

class FsDatabase {
  final _firestore =
      FirebaseFirestore.instance.collection("movies").withConverter<Movie>(
            fromFirestore: (snapshot, _) =>
                Movie.fromMovieFirstore(snapshot.data()!),
            toFirestore: (movie, _) => movie.toMovieFirestore(),
          );

// ! we need to add a current lsit update genre value future Task
// !follow the chatgpt other field like maps
  //?  add movie
  Future<void> addMovies(Movie moviemodel) async {
    await _firestore.add(moviemodel);

    // print(userRef);
  }

  // update movies
  Future<void> updateMovies(Movie moviemodel) async {
    await _firestore
        .doc("5hA5VMaeiE8TSxmsQiF7")
        .update(moviemodel.toMovieFirestore());
  }

//!delete a specific field in document
  // Future<void> deleteMovies() async {
  //   await _firestore
  //       .doc("z95NkgFWNOdoYUkDz8we")
  //       .update({"year": FieldValue.delete()});
  // }

// !delete the all documents
  Future<void> deleteMovies() async {
    await _firestore.doc("5hA5VMaeiE8TSxmsQiF7").delete();
  }

// !working with future
  // Future<dynamic> getMovies() async {
  //   final userDoc = await _firestore.get();
  //   // print(userDoc);
  //   if (userDoc.docs.isNotEmpty) {
  //     // List<dynamic> movieData = userDoc ;
  //     return userDoc.docs.map((e) => e.data()).toList();
  //   }
  //   return [];
  // }

// !get all data in the movies collections
  Stream<dynamic> getMoviesStream() {
    return _firestore.snapshots().map((data) {
      return data.docs.map((doc) {
        print(doc.data().genre);
        return doc.data();
      }).toList();
    });
  }

// ! get specific data in moves collection
  Stream<List<Movie>> getFiltermovies() {
    return _firestore.where("year", isEqualTo: 2024).snapshots().map(
      (data) {
        return data.docs.map((doc) {
          // print(doc.data().year);
          return doc.data();
        }).toList();
      },
    );
  }
}






//! These are the primary data types and structures you can use with Firestore:

//? Simple data types: Strings, numbers, booleans.
//? Arrays: Arrays of strings, numbers, or custom objects.
//? Maps: Nested objects.
//? Timestamps: For handling dates and times.
//? GeoPoints: For storing geographical coordinates.
//? Document References: For linking documents in different collections.
//? Transactions and Batches: For atomic operations.
// Practice CRUD operations with these various types and structures to fully understand how Firestore handles different data types.
//!  Firebase Concepts
//?  Summary of Practice Concepts:
//? Batch Writes
//? Transactions
//? Pagination
//? Real-Time Listeners
//? Subcollections
//? Complex Queries
//? Offline Persistence
//? Security Rules
//? Compound Queries
//? Error Handling

