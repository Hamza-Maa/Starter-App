// providers/post_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

// Provider for PostService
final postServiceProvider = Provider<PostService>((ref) {
  return PostService();
});

// StateNotifier for handling post actions (fetch, update, delete)
class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostService _postService;

  PostNotifier(this._postService) : super(const AsyncLoading()) {
    fetchPosts();
  }

  // Fetch all posts
  Future<void> fetchPosts() async {
    try {
      final posts = await _postService.fetchPosts();
      state = AsyncValue.data(posts);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Corrected with stack trace
    }
  }

  // Add a new post (mutating state)
  Future<void> addPost({required String title, required String body}) async {
    try {
      final newPost = await _postService.addPost(title, body);
      state = state
          .whenData((posts) => [...posts, newPost]); // Append new post to state
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Update an existing post by ID
  Future<void> updatePost(String id, Post updatedPost) async {
    try {
      final post = await _postService.updatePost(id, updatedPost);
      state = AsyncValue.data(state.asData!.value.map((p) {
        return p.id == id ? post : p;
      }).toList());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Corrected with stack trace
    }
  }

  // Refresh the posts
  Future<void> refresh() async {
    await fetchPosts(); // Calls fetchPosts to get new data
  }

  // Delete a post by ID
  Future<void> deletePost(String id) async {
    try {
      await _postService.deletePost(id);
      state = AsyncValue.data(
        state.asData!.value.where((post) => post.id != id).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Corrected with stack trace
    }
  }
}

// Provider for PostNotifier
final postProvider =
    StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>((ref) {
  return PostNotifier(ref.watch(postServiceProvider));
});
