import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../widgets/postcard_widget.dart';
import '../providers/post_providers.dart';
import '../providers/user_provider.dart';
import 'AddPostScreen.dart';
import 'ProfileScreen.dart';
import 'login_screen.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider);
    final postNotifier = ref.read(postProvider.notifier);
    final userNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white, // Cleaner background
      appBar: AppBar(
        title: const Text(
          'Community Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 10,
        backgroundColor: AppColors.softBlue, // Updated color
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              postNotifier.refresh();
            },
            splashRadius: 25,
          ),
        ],
      ),
      drawer: _buildDrawer(context, userNotifier),
      body: postState.when(
        data: (posts) => posts.isEmpty
            ? const Center(
                child: Text(
                  "No posts available.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.softBlue, // Updated color
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCardWidget(
                      post: post,
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this post?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await postNotifier.deletePost(post.id);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Post deleted successfully')),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.softBlue, // Updated color
            strokeWidth: 5,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Failed to load posts: $error',
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        backgroundColor: AppColors.coral, // Updated color
        icon: const Icon(Icons.add),
        label: const Text("Add Post"),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, userNotifier) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.softBlue, AppColors.peach], // Updated colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.softBlue, // Updated color
              ),
            ),
            accountEmail: Text(''),
          ),
          ListTile(
            leading: const Icon(Icons.list,
                color: AppColors.softBlue), // Updated color
            title: const Text('Posts',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person,
                color: AppColors.softBlue), // Updated color
            title: const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              userNotifier.logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
