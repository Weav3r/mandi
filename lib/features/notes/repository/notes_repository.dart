// lib/features/notes/repository/notes_repository.dart

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mandi/core/utils/appwrite_config.dart';
import 'package:mandi/services/appwrite_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository();
});

class NotesRepository {
  Future<DocumentList> fetchNotes() async {
    return await databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notesCollectionId,
    );
  }

  Future<Document> addNote(Map<String, dynamic> data, String userId) async {
    return await databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notesCollectionId,
      documentId: ID.unique(),
      data: data,
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId)),
      ],
    );
  }

  Future<void> deleteNote(String documentId) async {
    await databases.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notesCollectionId,
      documentId: documentId,
    );
  }
}
