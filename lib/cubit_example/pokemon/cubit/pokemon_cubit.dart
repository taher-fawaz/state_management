import 'package:flutter_bloc/flutter_bloc.dart';
import '../pokemon_repository.dart';
import 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final PokemonRepository repository;
  final int _pokemonsPerPage = 20;

  PokemonCubit({required this.repository}) : super(PokemonInitial());

  // Fetch the initial list of Pokemon
  Future<void> fetchPokemonList() async {
    emit(PokemonListLoading());
    try {
      final pokemonList = await repository.fetchPokemonList(
        limit: _pokemonsPerPage,
        offset: 0,
      );
      emit(PokemonListLoaded(
        pokemonList: pokemonList,
        offset: _pokemonsPerPage,
        hasReachedMax: pokemonList.length < _pokemonsPerPage,
      ));
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }

  // Load more Pokemon when scrolling (pagination)
  Future<void> loadMorePokemon() async {
    if (state is PokemonListLoaded) {
      final currentState = state as PokemonListLoaded;
      
      // Don't fetch more if we've reached the maximum
      if (currentState.hasReachedMax) return;
      
      try {
        final morePokemons = await repository.fetchPokemonList(
          limit: _pokemonsPerPage,
          offset: currentState.offset,
        );
        
        if (morePokemons.isEmpty) {
          // If no more Pokemon are returned, we've reached the max
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          // Add the new Pokemon to the existing list
          emit(PokemonListLoaded(
            pokemonList: [...currentState.pokemonList, ...morePokemons],
            offset: currentState.offset + _pokemonsPerPage,
            hasReachedMax: morePokemons.length < _pokemonsPerPage,
          ));
        }
      } catch (e) {
        emit(PokemonError(e.toString()));
      }
    }
  }

  // Fetch detailed information about a specific Pokemon
  Future<void> fetchPokemonDetails(String nameOrId) async {
    emit(PokemonDetailsLoading());
    try {
      final pokemon = await repository.fetchPokemonDetails(nameOrId);
      emit(PokemonDetailsLoaded(pokemon));
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }
}