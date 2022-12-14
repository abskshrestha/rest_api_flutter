import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Center(child: Text('REST API Call')),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          final color = user.gender == 'male' ? Colors.blue : Colors.green;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            textColor: Theme.of(context).textTheme.bodyText2?.color,
            title: Text(user.name.first),
            subtitle: Text(user.phone),
            tileColor: color,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          fetchUser();
        },
      ),
    );
  }

  fetchUser() async {
    print('fetchUser called');
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final results = json['results'] as List<dynamic>;
    final transformed = results.map(
      (e) {
        final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last'],
        );
        return User(
          cell: e['cell'],
          email: e['email'],
          gender: e['gender'],
          nat: e['nat'],
          phone: e['phone'],
          name: name
        );
      },
    ).toList();

    setState(() {
      users = transformed; //kkey
    });

    print('fetchUser completed');
  }
}
