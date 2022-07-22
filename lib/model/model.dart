import 'dart:convert';




class ImageModel {
  final String photographer;
  final String photographerUrl;
  final Src src;
  ImageModel({
    required this.photographer,
    required this.photographerUrl,
    required this.src,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'photographer': photographer});
    result.addAll({'photographerUrl': photographerUrl});
    result.addAll({'src': src.toMap()});
  
    return result;
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      photographer: map['photographer'] ?? '',
      photographerUrl: map['photographerUrl'] ?? '',
      src: Src.fromMap(map['src']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) => ImageModel.fromMap(json.decode(source));
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;
  Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'original': original});
    result.addAll({'large2x': large2x});
    result.addAll({'large': large});
    result.addAll({'medium': medium});
    result.addAll({'small': small});
    result.addAll({'portrait': portrait});
    result.addAll({'landscape': landscape});
    result.addAll({'tiny': tiny});
  
    return result;
  }

  factory Src.fromMap(Map<String, dynamic> map) {
    return Src(
      original: map['original'] ?? '',
      large2x: map['large2x'] ?? '',
      large: map['large'] ?? '',
      medium: map['medium'] ?? '',
      small: map['small'] ?? '',
      portrait: map['portrait'] ?? '',
      landscape: map['landscape'] ?? '',
      tiny: map['tiny'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Src.fromJson(String source) => Src.fromMap(json.decode(source));
}
