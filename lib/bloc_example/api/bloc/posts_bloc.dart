import 'package:flutter_bloc/flutter_bloc.dart';
import 'posts_event.dart';
import 'posts_state.dart';
import '../posts_repository.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({required this.repository}) : super(PostsInitial()) {
    on<PostsFetched>(_onPostsFetched);
  }

  Future<void> _onPostsFetched(PostsFetched event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final posts = await repository.fetchPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}