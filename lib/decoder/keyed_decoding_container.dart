part of dart_codable;

class KeyedDecodingContainer {
  final Map<String, dynamic> map;
  final Decoder decoder;

  KeyedDecodingContainer(this.decoder, this.map);

  T decode<T>(String key) {
    final value = map[key];

    final container = SingleValueDecodingContainer(decoder, value);

    return container.decode();
  }

  List<T> decodeList<T>(String key) {
    final value = map[key] as List;

    final list = value.map((e) {
      final container = SingleValueDecodingContainer(decoder, e);

      return container.decode<T>();
    }).toList();

    return list;
  }

  D decodeDecodable<D extends Decodable>(String key, Decoder<D> decoder) {
    final value = map[key] as Map<String, dynamic>;

    final object = decoder.decodeMap(value);

    return object;
  }

  List<D> decodeDecodableList<D extends Decodable>(
      String key, Decoder<D> decoder) {
    final listValue = map[key] as List<Map<String, dynamic>>;

    final objects = listValue.map((e) => decoder.decodeMap(e)).toList();

    return objects;
  }

  T tryDecode<T>(String key, {T defaultValue}) {
    try {
      return decode(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  List<T> tryDecodeList<T>(String key, {List<T> defaultValue}) {
    try {
      return decodeList(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  D tryDecodeDecodable<D extends Decodable>(String key, Decoder<D> decoder) {
    try {
      return decodeDecodable(key, decoder);
    } catch (e) {
      return null;
    }
  }

  List<D> tryDecodeDecodableList<D extends Decodable>(
      String key, Decoder<D> decoder) {
    try {
      return decodeDecodableList(key, decoder);
    } catch (e) {
      return null;
    }
  }

  KeyedDecodingContainer nestedKeyedContainer(String key) {
    final mapValue = map[key] as Map<String, dynamic>;

    return KeyedDecodingContainer(this.decoder, mapValue);
  }

  SingleValueDecodingContainer singleValueContainer() =>
      SingleValueDecodingContainer(decoder, map);
}
