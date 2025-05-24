import 'package:appwrite/appwrite.dart';
import 'package:mandi/core/utils/appwrite_config.dart';

final client = Client()
  ..setEndpoint(AppwriteConstants.endpoint)
  ..setProject(AppwriteConstants.projectId);

// Expose service instances
final databases = Databases(client);
final account = Account(client);
// Add storage, functions, etc. as needed
