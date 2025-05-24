// lib/features/notes/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mandi/core/widgets/add_note_dialog.dart';
import 'package:mandi/features/auth/providers/auth_controller.dart';
import 'package:mandi/features/notes/providers/notes_notifier.dart';
import 'package:appwrite/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider).logout();
              // TODO: Navigate to login screen after logout
            },
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet. Add one!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Slidable(
                key: ValueKey(note.$id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.5,
                  children: [
                    SlidableAction(
                      onPressed: (context) async {},
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        // Optimistically remove note from UI
                        ref
                            .read(notesNotifierProvider.notifier)
                            .removeNoteById(note.$id);

                        try {
                          await ref
                              .read(notesNotifierProvider.notifier)
                              .deleteNoteFromDb(note.$id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note deleted')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to delete note')),
                          );
                          // Re-fetch notes to restore UI in case of failure
                          await ref
                              .read(notesNotifierProvider.notifier)
                              .fetchNotes();
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    title: Text(
                      note.data['title'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: note.data['content'] != null &&
                            note.data['content'].toString().isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              note.data['content'],
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                    trailing: const Icon(Icons.note),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading notes: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context, WidgetRef ref) async {
    final newNote = await showDialog<Document>(
      context: context,
      builder: (_) => const AddNoteDialog(),
    );

    if (newNote != null) {
      ref.read(notesNotifierProvider.notifier).addNoteToList(newNote);
    }
  }
}
