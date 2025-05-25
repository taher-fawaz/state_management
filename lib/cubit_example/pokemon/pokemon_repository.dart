import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonRepository {
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  // Fetch a list of Pokemon with pagination
  Future<List<Map<String, dynamic>>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        // Return the list of Pokemon with their names and URLs
        return results.map((pokemon) => {
          'name': pokemon['name'],
          'url': pokemon['url'],
        }).toList();
      } else {
        throw Exception('Failed to load Pokemon list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Pokemon list: $e');
    }
  }

  // Fetch detailed information about a specific Pokemon
  Future<Pokemon> fetchPokemonDetails(String nameOrId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon/$nameOrId'));
      
      if (response.statusCode == 200) {
        return Pokemon.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Pokemon details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Pokemon details: $e');
    }
  }
}