import 'package:flutter/material.dart';
import './movie.dart';

void main() => runApp(MoviesApp());

int i = 0;

final List<Movie> movielist = Movie.get_movies();

class MoviesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Movies App'),
              backgroundColor: Colors.blueGrey,
            ),
            backgroundColor: Colors.blue,
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: movielist.length,
                itemBuilder: (context, i) {
                  return Stack(children: [
                    Positioned(
                      child: movieCard(movielist[i], context),
                    ),
                    Positioned(
                        left: 5,
                        top: 15,
                        bottom: 15,
                        child: movieImage(movielist[i]))
                  ]);
                })));
  }

  Widget movieCard(Movie movielist, BuildContext context) {
    return InkWell(
      child: Container(
          margin: const EdgeInsets.only(left: 30),
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Card(
              color: Colors.black,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 54.0, right: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(

                            //flex: 5,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Text(
                                    movielist.title ?? '0',
                                    style: const TextStyle(
                                        color: Colors.purple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(
                                  "\t\t\t\t\t\tRating -  "
                                  '${movielist.imdrating}'
                                  "/10.0",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Released in -" '${movielist.year}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        )
                      ])))),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MovieDetails(movielist.title ?? '0', movielist)));
      },
    );
  }

  Widget movieImage(Movie movielist) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(movielist.images?[i] ?? '0'),
              fit: BoxFit.cover)),
    );
  }
}

class MovieDetails extends StatelessWidget {
  String name;
  Movie movie;

  MovieDetails(this.name, this.movie);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Movie Details'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: [
          MovieDetailsThumbnail(movie.images?[i] ?? '0'),
          MovieWithHeaderPoster(movie),
          HorizontalLine(),
          MovieCast(movie),
          MoviewithExtraPosters(movie.images!),
        ],
      ),
    );
  }
}

class MovieDetailsThumbnail extends StatelessWidget {
  String thumbnail;

  MovieDetailsThumbnail(this.thumbnail);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(thumbnail), fit: BoxFit.cover)),
        ),
        const Icon(Icons.play_circle_outline_outlined,
            color: Colors.white, size: 80)
      ]),
      Container(
        margin: const EdgeInsets.only(top: 250),
        height: 30,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topCenter,
            colors: [Colors.lime, Colors.grey],
          ),
        ),
      ),
    ]);
  }
}

class MovieWithHeaderPoster extends StatelessWidget {
  Movie movie;
  MovieWithHeaderPoster(this.movie);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(children: [
          Movieposter(movie.images![i].toString()),
          const SizedBox(
            width: 16,
          ),
          Expanded(child: MoviesHeader(movie)),
        ]));
  }
}

class Movieposter extends StatelessWidget {
  String poster;
  Movieposter(this.poster);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(poster), fit: BoxFit.cover)),
            )));
  }
}

class MoviesHeader extends StatelessWidget {
  Movie movie;
  MoviesHeader(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('\n${movie.year}.${movie.genre}',
          style: const TextStyle(
              color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w500)),
      Text('\n${movie.title}',
          style: const TextStyle(
              color: Colors.black54,
              fontSize: 35,
              fontWeight: FontWeight.w700)),
      Text.rich(TextSpan(
          style: const TextStyle(
            fontSize: 20,
            color: Colors.purple,
          ),
          children: [
            TextSpan(text: '\n${movie.plot}'),
            const TextSpan(
                text: ' More......', style: TextStyle(color: Colors.blue))
          ]))
    ]);
  }
}

class MovieCast extends StatelessWidget {
  Movie movie;
  MovieCast(this.movie);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        Moviefield(field: "Cast", value: movie.actors),
        Moviefield(field: "Director", value: movie.director),
        Moviefield(field: "Awards", value: movie.awards),
        Moviefield(field: "Ratings", value: movie.imdrating)
      ]),
    );
  }
}

class Moviefield extends StatelessWidget {
  final String? field;
  final String? value;

  Moviefield({this.field, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\n${field} : ',
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.w500)),
        Expanded(
            child: Text('\n\t${value}',
                style: const TextStyle(fontSize: 20, color: Colors.black54)))
      ],
    );
  }
}

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: 220,
        height: 5,
        color: Colors.grey,
      ),
    );
  }
}

class MoviewithExtraPosters extends StatelessWidget {
  List<String> posters;

  MoviewithExtraPosters(this.posters);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('More movie posters',
                  style: TextStyle(color: Colors.purple, fontSize: 25)),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: posters.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 2,
                  ),
                  itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 160,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(posters[index]),
                                fit: BoxFit.cover)),
                      )),
                ),
              ),
            ]));
  }
}
