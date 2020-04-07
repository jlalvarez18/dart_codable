part of dart_codable;

typedef BoolDecodableFactory = bool Function(dynamic json);

class BoolDecoder {
  factory BoolDecoder.defaultDecoder() => BoolDecoder._((json) => json as bool);

  factory BoolDecoder.lossy() {
    return BoolDecoder._((json) {
      if (json is bool) {
        return json;
      }

      if (json is String) {
        final value = json.toLowerCase();

        if (value == 'true') {
          return true;
        }

        if (json.toLowerCase() == 'false') {
          return false;
        }
      }

      if (json is num) {
        final value = json.toInt();

        if (value == 0) {
          return false;
        }

        if (value == 1) {
          return true;
        }
      }

      throw 'Invalid json type: ${json.runtimeType}';
    });
  }

  factory BoolDecoder.decodeCustom(BoolDecodableFactory factory) =>
      BoolDecoder._(factory);

  bool decode(dynamic json) => _factory(json);

  final BoolDecodableFactory _factory;
  BoolDecoder._(this._factory);
}
