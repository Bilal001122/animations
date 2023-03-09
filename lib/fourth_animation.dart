import 'package:flutter/material.dart';

class AnimationFourthOne extends StatefulWidget {
  const AnimationFourthOne({Key? key}) : super(key: key);

  @override
  State<AnimationFourthOne> createState() => _AnimationFourthOneState();
}

class _AnimationFourthOneState extends State<AnimationFourthOne> {
  final List<Person> people = [
    Person(name: 'John', age: 20, emoji: Icons.person),
    Person(name: 'Jane', age: 21, emoji: Icons.person),
    Person(name: 'Jack', age: 22, emoji: Icons.person),
    Person(name: 'Jill', age: 23, emoji: Icons.person),
    Person(name: 'Joe', age: 24, emoji: Icons.person),
    Person(name: 'Joan', age: 25, emoji: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsPage(person: person),
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Icon(
                person.emoji,
              ),
            ),
            title: Text(
              person.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text('${person.age} years old'),
          );
        },
      ),
    );
  }
}

class Person {
  final String name;
  final int age;
  final IconData emoji;

  Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

class DetailsPage extends StatefulWidget {
  final Person person;

  const DetailsPage({Key? key, required this.person}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Hero(
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              switch(flightDirection){
                case HeroFlightDirection.push:
                  return ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(begin: 0.0, end: 1.3).chain(
                        CurveTween(curve: Curves.decelerate),
                      ),
                    ),
                    child: toHeroContext.widget,
                  );
                case HeroFlightDirection.pop:
                  return ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(begin: 1.3, end: 0.0).chain(
                        CurveTween(curve: Curves.decelerate),
                      ),
                    ),
                    child: fromHeroContext.widget,
                  );
              }
            },
            tag: widget.person.name,
            child: Icon(widget.person.emoji,size: 40,),
          ),
        ),
      ),
      body: Text(
        '${widget.person.name} is ${widget.person.age} years old',
        style: const TextStyle(fontSize: 40),
      ),
    );
  }
}
