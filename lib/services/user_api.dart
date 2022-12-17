import 'dart:convert';

import '../models/user.dart';
import '../models/user_dob.dart';
import '../models/user_name.dart';
import 'package:http/http.dart' as http;

class UserApi {
 static Future<List<User>> fetchUser() async {

    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final results = json['results'] as List<dynamic>;
    final users = results.map(
      (e) {
        final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last'],
        );
        final date = e['dob']['date'];

        final dob = UserDob(
          age: e['dob']['age'],
          date: DateTime.parse(date),
        );
        return User(
            cell: e['cell'],
            email: e['email'],
            gender: e['gender'],
            nat: e['nat'],
            phone: e['phone'],
            name: name,
            dob: dob);
      },
    ).toList();
    return users;




  }
}