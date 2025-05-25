import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/pokemon.dart';
import 'pokemon_model.dart';
import 'pokemon_repository.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonId;
  final bool useNewCubit;

  const PokemonDetailPage({
    super.key, 
    required this.pokemonId,
    this.useNewCubit = true, // Default to using a new cubit to avoid state conflicts
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  @override
  void initState() {
    super.initState();
    // Only fetch details if we're not using a new cubit
    // If we're using a new cubit, it will be created in the build method
    if (!widget.useNewCubit) {
      context.read<PokemonCubit>().fetchPokemonDetails(widget.pokemonId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If useNewCubit is true, create a new cubit instance for this page
    // This prevents state conflicts when navigating back to the list
    if (widget.useNewCubit) {
      return BlocProvider(
        create: (_) {
          final cubit = PokemonCubit(repository: PokemonRepository());
          cubit.fetchPokemonDetails(widget.pokemonId);
          return cubit;
        },
        child: _buildDetailScaffold(),
      );
    }
    
    // Otherwise use the existing cubit from the parent
    return _buildDetailScaffold();
  }
  
  Widget _buildDetailScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PokemonCubit, PokemonState>(
        builder: (context, state) {
          if (state is PokemonDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PokemonDetailsLoaded) {
            return _buildPokemonDetails(state.pokemon);
          } else if (state is PokemonError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildPokemonDetails(Pokemon pokemon) {
    // Get the color based on the first type of the Pokemon
    final Color typeColor =
        _getTypeColor(pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: typeColor.withOpacity(0.3),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.catching_pokemon, size: 200);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '#${pokemon.id} ${pokemon.name.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTypeChips(pokemon.types),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Base Stats',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow('Height', '${pokemon.height / 10} m'),
                    _buildStatRow('Weight', '${pokemon.weight / 10} kg'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChips(List<String> types) {
    return Wrap(
      spacing: 8,
      children: types.map((type) {
        final Color color = _getTypeColor(type);
        return Chip(
          backgroundColor: color,
          label: Text(
            type.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.grey.shade500;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.amber;
      case 'grass':
        return Colors.green;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.brown;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown.shade300;
      case 'flying':
        return Colors.indigo.shade200;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.grey.shade700;
      case 'ghost':
        return Colors.indigo;
      case 'dragon':
        return Colors.indigo.shade800;
      case 'dark':
        return Colors.grey.shade800;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pinkAccent.shade100;
      default:
        return Colors.grey;
    }
  }
}
