part of dart_codable;

typedef DecoadbleFactory<T extends Decodable> = T Function(Decoder<T>);

class Decoder<T extends Decodable> {
  final DecoadbleFactory<T> _factory;

  Decoder(this._factory);

  DateTimeDecoder dateTimeDecoder = DateTimeDecoder.decodeString();
  DataDecoder dataDecoder = DataDecoder.decodeBase64();

  dynamic _value;

  KeyedDecodingContainer keyedContainer() =>
      KeyedDecodingContainer(this, _value as Map<String, dynamic>);

  SingleValueDecodingContainer singleValueContainer() =>
      SingleValueDecodingContainer(this, _value);

  T decodeMap(Map<String, dynamic> json) {
    assert(json != null);

    _value = json;

    final object = _factory(this);

    object.decode(this);

    return object;
  }

  List<T> decodeList(List<Map<String, dynamic>> json) {
    assert(json != null);

    _value = json;

    final objects = json.map((e) => decodeMap(e)).toList();

    return objects;
  }
}
