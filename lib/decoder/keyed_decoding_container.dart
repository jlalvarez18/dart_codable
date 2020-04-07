part of dart_codable;

class KeyedDecodingContainer {
  final Map<String, dynamic> map;
  final Decoder decoder;

  KeyedDecodingContainer(this.decoder, this.map);

  T decode<T>(String keyPath) {
    assert(keyPath != null);

    final value = map.getValue(keyPath);

    final container = SingleValueDecodingContainer(decoder, value);

    return container.decode();
  }

  List<T> decodeList<T>(String keyPath) {
    assert(keyPath != null);

    final value = map.getValue(keyPath) as List;

    final list = value.map((e) {
      final container = SingleValueDecodingContainer(decoder, e);

      return container.decode<T>();
    }).toList();

    return list;
  }

  D decodeDecodable<D extends Decodable>(String keyPath, Decoder<D> decoder) {
    assert(keyPath != null);
    assert(decoder != null);

    final value = map.getValue(keyPath);

    if (value is Map<String, dynamic>) {
      final object = decoder.decodeMap(value);

      return object;
    }

    throw 'Invalid type: ${value.runtimeType}';
  }

  List<D> decodeDecodableList<D extends Decodable>(
      String keyPath, Decoder<D> decoder) {
    assert(keyPath != null);
    assert(decoder != null);

    final value = map.getValue(keyPath) as List;

    final List<Map<String, dynamic>> list = List.castFrom(value);

    final objects = list.map((e) => decoder.decodeMap(e)).toList();

    return objects;
  }

  T tryDecode<T>(String keyPath, {T defaultValue}) {
    try {
      return decode(keyPath) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  List<T> tryDecodeList<T>(String keyPath, {List<T> defaultValue}) {
    try {
      return decodeList(keyPath) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  D tryDecodeDecodable<D extends Decodable>(
      String keyPath, Decoder<D> decoder) {
    try {
      return decodeDecodable(keyPath, decoder);
    } catch (e) {
      return null;
    }
  }

  List<D> tryDecodeDecodableList<D extends Decodable>(
      String keyPath, Decoder<D> decoder) {
    try {
      return decodeDecodableList(keyPath, decoder);
    } catch (e) {
      return null;
    }
  }

  KeyedDecodingContainer nestedKeyedContainer(String keyPath) {
    final value = map.getValue(keyPath);

    if (value is Map<String, dynamic>) {
      return KeyedDecodingContainer(this.decoder, value);
    }

    throw 'Invalid type: ${value.runtimeType}';
  }

  SingleValueDecodingContainer singleValueContainer() =>
      SingleValueDecodingContainer(decoder, map);
}

extension MapKeyPath<V> on Map<String, V> {
  /// Keypath can be a dot separated list of keys eg:
  /// {
  ///   'name': {
  ///       'first': 'John',
  ///       'last': 'Doe'
  ///   }
  /// }
  /// final name = map.getValue('name.first');
  /// print(name) => 'Juan'
  ///
  /// You can also include an index if the path contains a list eg:
  /// {
  ///   'addresses':
  ///   [
  ///     {'city': 'Round Rock', 'state': 'Texas'},
  ///     {'city': 'Austin', 'state': 'Texas}
  ///   ]
  /// }
  /// final primaryCity = map.getValue('addresses.0.city');
  /// print(primaryCity) => 'Round Rock'
  V getValue<V>(String keyPath) {
    dynamic current = this;

    keyPath.split('.').forEach((key) {
      final maybeInt = int.tryParse(key);

      if (maybeInt != null && current is List) {
        current = current[maybeInt];
      } else if (current is Map) {
        current = current[key];
      }
    });

    return (current as V);
  }
}
