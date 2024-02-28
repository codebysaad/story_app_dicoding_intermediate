// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DetailsStoryResponse welcomeFromJson(String str) => DetailsStoryResponse.fromJson(json.decode(str));

String welcomeToJson(DetailsStoryResponse data) => json.encode(data.toJson());

class DetailsStoryResponse {
  bool error;
  String message;
  StoryDetails story;

  DetailsStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailsStoryResponse.fromJson(Map<String, dynamic> json) => DetailsStoryResponse(
    error: json["error"],
    message: json["message"],
    story: StoryDetails.fromJson(json["story"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "story": story.toJson(),
  };
}

class StoryDetails {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  StoryDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory StoryDetails.fromJson(Map<String, dynamic> json) => StoryDetails(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };
}
