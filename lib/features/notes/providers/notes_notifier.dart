import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mandi/features/notes/repository/notes_repository.dart';

class NotesNotifier extends AsyncNotifier<List<Document>> {
  late final NotesRepository _repository;

  @override
  Future<List<Document>> build() async {
    _repository = ref.read(notesRepositoryProvider);
    return await fetchNotes();
  }

  Future<List<Document>> fetchNotes() async {
    try {
      final docs = await _repository.fetchNotes();
      state = AsyncData(docs.documents);
      return docs.documents;
    } catch (e, st) {
      state = AsyncError(e, st);
      return [];
    }
  }

  Future<void> addNoteToList(Document newNote) async {
    state = AsyncData([...state.value ?? [], newNote]);
  }

  void removeNoteById(String id) {
    final updated = state.value?.where((note) => note.$id != id).toList() ?? [];
    state = AsyncData(updated);
  }

  Future<void> deleteNoteFromDb(String id) async {
    await _repository.deleteNote(id);
  }
}

final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, List<Document>>(NotesNotifier.new);
