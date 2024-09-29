// screens/modifypost_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../providers/post_providers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ModifyPostScreen extends ConsumerStatefulWidget {
  final Post post;

  const ModifyPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _ModifyPostScreenState createState() => _ModifyPostScreenState();
}

class _ModifyPostScreenState extends ConsumerState<ModifyPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postNotifier = ref.read(postProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title TextField
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
            // Body TextField
            CustomTextField(
              controller: _bodyController,
              hintText: 'Body',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the body text';
                }
                return null;
              },
            ),
            const SizedBox(height: 24.0),
            // Save Button
            CustomButton(
              text: 'Save',
              onPressed: () async {
                final updatedPost = widget.post.copyWith(
                  title: _titleController.text,
                  body: _bodyController.text,
                );
                try {
                  await postNotifier.updatePost(widget.post.id, updatedPost);
                  Navigator.pop(context); // Go back after saving
                } catch (error) {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${error.toString()}')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
