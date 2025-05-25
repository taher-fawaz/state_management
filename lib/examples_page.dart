import 'package:flutter/material.dart';
import 'set_state_example/counter_page.dart';
import 'bloc_example/counter/counter_page.dart';
import 'bloc_example/api/posts_page.dart';
import 'cubit_example/counter/counter_page.dart';
import 'cubit_example/api/posts_page.dart';
import 'cubit_example/pokemon/pokemon_list_page.dart';

class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Flutter State Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore different state management approaches in Flutter',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildExampleCard(
                context,
                title: 'setState Counter Example',
                description:
                    'The simplest form of state management using setState',
                icon: Icons.add_circle,
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SetStateCounterPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildExampleCard(
                context,
                title: 'BLoC Counter Example',
                description: 'Counter implementation using the BLoC pattern',
                icon: Icons.add_circle_outline,
                color: Colors.green,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BlocCounterPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildExampleCard(
                context,
                title: 'BLoC API Example',
                description:
                    'Fetching and displaying data from an API using BLoC',
                icon: Icons.cloud_download,
                color: Colors.purple,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PostsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildExampleCard(
                context,
                title: 'Cubit Counter Example',
                description: 'Counter implementation using the Cubit pattern',
                icon: Icons.add_circle_outline,
                color: Colors.orange,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CubitCounterPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildExampleCard(
                context,
                title: 'Cubit API Example',
                description:
                    'Fetching and displaying data from an API using Cubit',
                icon: Icons.cloud_download,
                color: Colors.teal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CubitPostsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildExampleCard(
                context,
                title: 'Pokémon Repository Pattern',
                description:
                    'Repository Pattern with Cubit using PokeAPI',
                icon: Icons.catching_pokemon,
                color: Colors.red,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PokemonListPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
