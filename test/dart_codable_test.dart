import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_codable/dart_codable.dart';

void main() {
  final personJson = <String, dynamic>{
    'first_name': 'John',
    'last_name': 'Doe',
    'birthday': '1983-11-23',
    'is_married': 1,
    'addresses': [
      {'city': 'Round Rock', 'state': 'Texas'}
    ],
    'spouse': {
      'first_name': 'Jane',
      'last_name': 'Doe',
      'birthday': '1980-12-11',
      'is_married': 'True',
    }
  };

  test('Person decoder', () {
    final personDecoder =
        Decoder((Decoder<Person> decoder) => Person.fromDecoder(decoder));
    personDecoder.boolDecoder = BoolDecoder.lossy();

    final person = personDecoder.decodeMap(personJson);

    expect(person.fullName, 'John Doe');
    expect(person.birthday, isNotNull);
    expect(person.addresses, isNotEmpty);
    expect(person.spouse, isNotNull);
    expect(person.primaryCity, 'Round Rock');
  });

  test('json string', () {
    final jsonList = [personJson];

    final source = jsonEncode(jsonList);

    final personDecoder =
        Decoder((Decoder<Person> decoder) => Person.fromDecoder(decoder));
    personDecoder.boolDecoder = BoolDecoder.lossy();

    final people = personDecoder.decodeJsonList(source);

    final person = people[0];

    expect(person.fullName, 'John Doe');
    expect(person.birthday, isNotNull);
    expect(person.addresses, isNotEmpty);
    expect(person.spouse, isNotNull);
    expect(person.primaryCity, 'Round Rock');
  });
}

@immutable
class Person extends Decodable {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final List<Address> addresses;
  final Person spouse;

  final String primaryCity;
  final bool isMarried;

  String get fullName => '$firstName $lastName';

  Person({
    this.firstName,
    this.lastName,
    this.birthday,
    this.addresses,
    this.spouse,
    this.primaryCity,
    this.isMarried,
  });

  factory Person.fromDecoder(Decoder<Person> decoder) {
    final container = decoder.keyedContainer();

    final String firstName = container.decode('first_name');
    final String lastName = container.decode('last_name');
    final DateTime birthday = container.decode('birthday');

    final addressDecoder = Decoder((decoder) => Address());
    final addresses =
        container.tryDecodeDecodableList('addresses', addressDecoder) ?? [];

    final spouse = container.tryDecodeDecodable('spouse', decoder);

    final String primaryCity = container.tryDecode('addresses.0.city');

    final bool isMarried = container.decode('is_married');

    return Person(
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      addresses: addresses,
      spouse: spouse,
      primaryCity: primaryCity,
      isMarried: isMarried,
    );
  }

  @override
  void decode(Decoder decoder) {
    // No-Op since object is immutable
  }
}

class Address extends Decodable {
  String city;
  String state;

  @override
  void decode(Decoder<Decodable> decoder) {
    final container = decoder.keyedContainer();

    city = container.decode('city');
    state = container.decode('state');
  }
}
