part of dart_codable;

typedef DecoadbleFactory<T extends Decodable> = T Function(Decoder<T>);

class Decoder<T extends Decodable> {
  final DecoadbleFactory<T> _factory;

  Decoder(this._factory);

  DateTimeDecoder dateTimeDecoder = DateTimeDecoder.decodeString();
  DataDecoder dataDecoder = DataDecoder.decodeBase64();
  BoolDecoder boolDecoder = BoolDecoder.defaultDecoder();

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

  T decodeJsonMap(String jsonString) {
    assert(jsonString != null);

    final value = jsonDecode(jsonString);

    if (value is Map) {
      final Map<String, dynamic> map = Map.castFrom(value);

      return decodeMap(map);
    }

    throw 'Invalid type: ${value.runtimeType}';
  }

  List<T> decodeJsonList(String jsonString) {
    assert(jsonString != null);

    final value = jsonDecode(jsonString);

    if (value is List) {
      final List<Map<String, dynamic>> list = List.castFrom(value);

      return decodeList(list);
    }

    throw 'Invalid type: ${value.runtimeType}';
  }
}
