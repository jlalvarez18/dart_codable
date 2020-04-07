part of dart_codable;

typedef DataDecodableFactory = Uint8List Function(dynamic json);

class DataDecoder {
  factory DataDecoder.decodeBase64() =>
      DataDecoder._((json) => base64Decode(json as String));

  factory DataDecoder.decodeCustom(DataDecodableFactory factory) =>
      DataDecoder._(factory);

  Uint8List decode(dynamic json) => _factory(json);

  final DataDecodableFactory _factory;
  DataDecoder._(this._factory);
}
