import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:story_app/data/models/details_story_response.dart';
import 'package:story_app/data/models/general_response.dart';
import 'package:story_app/data/models/login_response.dart';
import 'package:story_app/data/models/maps_response.dart';
import 'package:story_app/data/models/stories_response.dart';

class ApiServices {
  final http.Client client;
  ApiServices(this.client);

  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<GeneralResponse> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try{
      final response = await client.post(
        url,
        body: <String, String>{
          'name': name,
          'email': email,
          'password': password
        },
      );
      return GeneralResponse.fromJson(json.decode(response.body));
    }catch(e){
      throw Exception('Error: $e');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try{
      final response = await client.post(
        url,
        body: <String, String>{
          'email': email,
          'password': password
        },
      );
      log('ApiLogin: ${response.body}');
      return LoginResponse.fromJson(json.decode(response.body));
    }catch(e){
      throw Exception('Error: $e');
    }
  }

  Future<StoriesResponse> getAllStories(String token, [int pageItem = 1, int sizeItem = 10]) async {
    final url = Uri.parse('$baseUrl/stories?page=$pageItem&size=$sizeItem&location=0');
    final response = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },

    );
    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<MapsResponse> getAllStoriesMaps(String token) async {
    final url = Uri.parse('$baseUrl/stories?location=1');
    final response = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },

    );
    if (response.statusCode == 200) {
      return MapsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<DetailsStoryResponse> getStoryDetails(String token, String id) async {
    final url = Uri.parse('$baseUrl/stories/$id');
    final response = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },

    );
    if (response.statusCode == 200) {
      return DetailsStoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<GeneralResponse> addNewStory(String token, List<int> bytes, String description, String fileName, double? lat, double? lon) async {
    try {
      final url = Uri.parse('$baseUrl/stories');
      var request = http.MultipartRequest('POST', url);
      final multiPartFile = http.MultipartFile.fromBytes("photo", bytes,
          filename: fileName);

      final Map<String, String> fields = {
        'description': description,
        'lat': lat?.toString() ?? '0.0',
        'lon': lon?.toString() ?? '0.0',
      };

      final Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        'Authorization': 'Bearer $token',
      };

      request.files.add(multiPartFile);
      request.fields.addAll(fields);
      request.headers.addAll(headers);

      final http.StreamedResponse streamedResponse = await request.send();
      final int statusCode = streamedResponse.statusCode;

      final Uint8List responseList = await streamedResponse.stream.toBytes();
      final String responseData = String.fromCharCodes(responseList);

      if (statusCode == 201) {
        return GeneralResponse.fromJson(json.decode(responseData));
      } else {
        throw Exception('Failed to load data');
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}