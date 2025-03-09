import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/constants/appwrite_constants.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.read(appwriteClientProvider);
  return Databases(client);
});

final authStateProvider = StateProvider<bool>((ref) => false);
