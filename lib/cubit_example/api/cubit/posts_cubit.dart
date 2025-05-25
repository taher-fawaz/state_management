import 'package:flutter_bloc/flutter_bloc.dart';
import 'posts_state.dart';
import '../posts_repository.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepository repository;

  PostsCubit({required this.repository}) : super(PostsInitial());

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final posts = await repository.fetchPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}