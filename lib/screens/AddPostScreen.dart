// screens/addpost_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_providers.dart';

import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postNotifier = ref.read(postProvider.notifier);

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        backgroundColor: AppColors.deepNavy,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title Field
              CustomTextField(
                controller: _titleController,
                hintText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Body Field
              CustomTextField(
                controller: _bodyController,
                hintText: 'Body',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              // Submit Button
              CustomButton(
                text: 'Add Post',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    postNotifier
                        .addPost(
                      title: _titleController.text,
                      body: _bodyController.text,
                    )
                        .then((_) {
                      Navigator.pop(context); // Go back to the post list
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
