import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/pokemon.dart';
import 'pokemon_repository.dart';
import 'pokemon_detail_page.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = PokemonCubit(repository: PokemonRepository());
        cubit.fetchPokemonList();
        return cubit;
      },
      child: const PokemonListView(),
    );
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonCubit>().loadMorePokemon();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we need to reload the list when returning from detail page
    final state = context.read<PokemonCubit>().state;
    if (state is! PokemonListLoaded &&
        state is! PokemonListLoading &&
        state is! PokemonInitial) {
      // If we're not in a list-related state, reload the list
      context.read<PokemonCubit>().fetchPokemonList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PokemonCubit, PokemonState>(
        builder: (context, state) {
          if (state is PokemonInitial ||
              state is PokemonListLoading &&
                  (state as PokemonListLoading).props.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PokemonListLoaded) {
            return _buildPokemonList(state);
          } else if (state is PokemonError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            // Trigger a reload if we're in an unexpected state
            if (!(state is PokemonDetailsLoading ||
                state is PokemonDetailsLoaded)) {
              Future.microtask(
                  () => context.read<PokemonCubit>().fetchPokemonList());
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildPokemonList(PokemonListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PokemonCubit>().fetchPokemonList();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax
            ? state.pokemonList.length
            : state.pokemonList.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.pokemonList.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final pokemon = state.pokemonList[index];
          final pokemonName = pokemon['name'];
          final pokemonUrl = pokemon['url'];

          // Extract the Pokemon ID from the URL
          final uri = Uri.parse(pokemonUrl);
          final pathSegments = uri.pathSegments;
          final pokemonId = pathSegments[pathSegments.length - 2];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Hero(
                tag: 'pokemon-$pokemonId',
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png',
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.catching_pokemon, size: 50);
                  },
                ),
              ),
              title: Text(
                pokemonName.toString().toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('ID: $pokemonId'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PokemonDetailPage(
                      pokemonId: pokemonId,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
