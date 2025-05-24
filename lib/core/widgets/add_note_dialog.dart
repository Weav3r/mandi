import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mandi/features/auth/providers/auth_provider.dart';
import 'package:mandi/features/notes/repository/notes_repository.dart';

class AddNoteDialog extends ConsumerStatefulWidget {
  const AddNoteDialog({super.key});

  @override
  ConsumerState<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends ConsumerState<AddNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  bool _isSubmitting = false;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final notesRepository = ref.read(notesRepositoryProvider);
      final userId = ref.read(authStateProvider).asData?.value?.userId;

      if (userId == null) {
        // User not logged in, show error or navigate away
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
        return;
      }

      final data = {
        'title': _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
      };

      // Call the repository method that returns the created Document
      final createdNote = await notesRepository.addNote(data, userId);

      if (mounted) {
        Navigator.of(context)
            .pop(createdNote); // Pass back the created document
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Note'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Content'),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
