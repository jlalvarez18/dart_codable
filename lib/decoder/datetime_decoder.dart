part of dart_codable;

typedef DateTimeDecodableFactory = DateTime Function(dynamic json);

class DateTimeDecoder {
  factory DateTimeDecoder.decodeString() =>
      DateTimeDecoder._((json) => DateTime.parse(json as String));

  factory DateTimeDecoder.decodeMilliseconds() => DateTimeDecoder._(
      (json) => DateTime.fromMillisecondsSinceEpoch((json as num).toInt()));

  factory DateTimeDecoder.decodeMicroseconds() => DateTimeDecoder._(
      (json) => DateTime.fromMicrosecondsSinceEpoch((json as num).toInt()));

  factory DateTimeDecoder.decodeCustom(DateTimeDecodableFactory factory) =>
      DateTimeDecoder._(factory);

  DateTime decode(dynamic json) => _factory(json);

  DateTimeDecodableFactory _factory;
  DateTimeDecoder._(this._factory);
}
