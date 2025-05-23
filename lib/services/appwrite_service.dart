import 'package:appwrite/appwrite.dart';

final client = Client();

Future<void> initAppwrite() async {
  client
      .setEndpoint('https://fra.cloud.appwrite.io/v1')
      .setProject('682dabbd002f9fb97490');
  // .setSelfSigned(status: true); // Only for local dev
}
