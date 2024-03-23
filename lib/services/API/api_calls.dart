import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gamedatabaseapp/services/API/api_key.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:io';


class PopularGamesLast30Days {
  static Future<List<Game>> fetchPopularGamesLast30Days() async {
    final apiKey = ApiKeys.rawgApiKey;
    final DateTime today = DateTime.now();
    final DateTime thirtyDaysFromNow = today.add(Duration(days: 30));

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(today);
    final String endDate = formatter.format(thirtyDaysFromNow);
    final url = 'https://api.rawg.io/api/games?key=$apiKey&page_size=5&dates=$startDate,$endDate&ordering=-rating';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> gamesList = responseData['results'];
        
        List<Game> gameDataList = gamesList.map((game) {
          return Game(
            id: game['id'],
            name: game['name'].toString(),
            released: game['released'].toString(),
            backgroundImage: game['background_image'].toString(),
            rating: game['rating'],          
            description: game['description_raw'].toString(),

          );
        }).toList();
        return gameDataList;
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error loading popular games: $error');
      throw Exception('Failed to load data');
    }
  }
}


class GameDetailsService { 

  Future<Game> fetchGameDetailsById(int gameId) async {
    final url = 'https://api.rawg.io/api/games/$gameId?key=${ApiKeys.rawgApiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        return Game.fromJson(responseData);
      } else {
        throw Exception('Failed to load game details');
      }
    } catch (error) {
      print('Error fetching game details: $error');
      throw Exception('Failed to load game details');
    }
  }
}


class PopularRPGGames {
  static Future<List<Game>> fetchPopularRPGGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=5'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularStrategyGames {
  static Future<List<Game>> fetchPopularStrategyGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=strategy'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class APISearch {
  static Future<List<Game>> searchGames(String query) async {
    final apiKey = ApiKeys.rawgApiKey;
    try {
      final Uri uri = Uri.parse('https://api.rawg.io/api/games').replace(
        queryParameters: {'key': '$apiKey', 'search': query},
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load games');
      }
    } catch (e) {
      print('Network Error: $e');
      throw Exception('Failed to load games');
    }
  }
}
Future<String?> fetchGameImage(String gameName) async {
  final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&search=$gameName',
  
    ),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body)['results'];
    
    if (data.isNotEmpty) {
      return data.first['background_image'];
    } else {
      return null; 
    }
  } else {
    print('Failed to fetch game image: ${response.statusCode}');
    return null;
  }
}
class GameDetails { 

  static Future<Game?> fetchGameDetails(String gameName) async {
   
    final encodedGameName = Uri.encodeComponent(gameName); 
    final url = Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&search=$encodedGameName');

   
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

     
      if (data['results'] != null && data['results'].isNotEmpty) {
        final firstResult = data['results'][0]; 
        return Game.fromJson(firstResult);
      } else {
        return null; 
      }

    } else {
      throw Exception('Failed to load game details');
    }
  }
}
class PopularShooterGames { 
  static Future<List<Game>> fetchPopularShooterGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=shooter')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularRPGgames { 
  static Future<List<Game>> fetchPopularRPGGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=5')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularAdventureGames { 
  static Future<List<Game>> fetchPopularAdventureGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=adventure')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularPuzzleGames { 
  static Future<List<Game>> fetchPopularPuzzleGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=puzzle')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularRacingGames { 
  static Future<List<Game>> fetchPopularRacingGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=racing')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class PopularSimulationGames { 
  static Future<List<Game>> fetchPopularSimulationGames() async {
    final response = await http.get(Uri.parse('${ApiKeys.baseUrl}?key=${ApiKeys.rawgApiKey}&genres=simulation')); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
