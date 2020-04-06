import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_codable/dart_codable.dart';

void main() {
  test('adds one to input values', () {
    final json = <String, dynamic>{
      'first_name': 'Juan',
      'last_name': 'Alvarez',
      'birthday': '1983-11-23',
      'addresses': [
        {'city': 'Round Rock', 'state': 'Texas'}
      ],
      'spouse': {
        'first_name': 'Desaree',
        'last_name': 'Alvarez',
        'birthday': '1980-12-11',
      }
    };

    final personDecoder =
        Decoder((Decoder<Person> decoder) => Person.fromDecoder(decoder));

    final person = personDecoder.decodeMap(json);

    print(person.fullName);
    print(person.birthday);
    print(person.addresses);
    print(person.spouse);
  });
}

@immutable
class Person extends Decodable {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final List<Address> addresses;
  final Person spouse;

  String get fullName => '$firstName $lastName';

  Person({
    this.firstName,
    this.lastName,
    this.birthday,
    this.addresses,
    this.spouse,
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

    return Person(
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      addresses: addresses,
      spouse: spouse,
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
