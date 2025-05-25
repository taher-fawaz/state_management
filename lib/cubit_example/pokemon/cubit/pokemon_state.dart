import 'package:equatable/equatable.dart';
import '../pokemon_model.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();
  
  @override
  List<Object> get props => [];
}

// Initial state when the app starts
class PokemonInitial extends PokemonState {}

// State when Pokemon list is being loaded
class PokemonListLoading extends PokemonState {}

// State when Pokemon list has been loaded successfully
class PokemonListLoaded extends PokemonState {
  final List<Map<String, dynamic>> pokemonList;
  final int offset;
  final bool hasReachedMax;

  const PokemonListLoaded({
    required this.pokemonList,
    required this.offset,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [pokemonList, offset, hasReachedMax];

  PokemonListLoaded copyWith({
    List<Map<String, dynamic>>? pokemonList,
    int? offset,
    bool? hasReachedMax,
  }) {
    return PokemonListLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      offset: offset ?? this.offset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// State when Pokemon details are being loaded
class PokemonDetailsLoading extends PokemonState {}

// State when Pokemon details have been loaded successfully
class PokemonDetailsLoaded extends PokemonState {
  final Pokemon pokemon;

  const PokemonDetailsLoaded(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

// State when an error occurs
class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object> get props => [message];
}