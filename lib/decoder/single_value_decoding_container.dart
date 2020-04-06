part of dart_codable;

class SingleValueDecodingContainer {
  final dynamic value;
  final Decoder decoder;

  SingleValueDecodingContainer(this.decoder, this.value);

  T decode<T>({T defaultValue}) {
    return _unbox(value) ?? defaultValue;
  }

  D decodeDecodable<D extends Decodable>(Decoder<D> decoder) {
    final object = decoder.decodeMap(value as Map<String, dynamic>);

    return object;
  }

  T _unbox<T>(dynamic value) {
    if (T == String || T == bool) {
      return value as T;
    }

    if (T == int) {
      return (value as num).toInt() as T;
    }

    if (T == double) {
      return (value as num).toDouble() as T;
    }

    if (T == DateTime) {
      return decoder.dateTimeDecoder.decode(value) as T;
    }

    if (T == Map) {
      final map = value as Map<String, dynamic>;

      final newMap = map.map((key, value) {
        final newValue = _unbox(value);

        return MapEntry(key, newValue);
      });

      return newMap as T;
    }

    if (T == Uint8List) {
      return decoder.dataDecoder.decode(value) as T;
    }

    return null;
  }
}
