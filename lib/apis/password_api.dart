import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pack_n_deliver/constants/appwrite_constants.dart';
import 'package:pack_n_deliver/core/failure.dart';
import 'package:pack_n_deliver/core/providers.dart';
import 'package:pack_n_deliver/core/type_def.dart';

final passworAPIProvider = Provider((ref) {
  final databases = ref.read(appwriteDatabaseProvider);
  return PasswordApi(databases: databases);
});

class PasswordApi {
  final Databases _databases;
  PasswordApi({required Databases databases}) : _databases = databases;

  FutureEither<String> getPassword() async {
    try {
      final response = await _databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.globalCollectionID,
        documentId: 'password',
      );
      if (response.data.containsKey('value')) {
        return right(response.data['value'] as String);
      } else {
        return left(
          Failure('Password field missing in document', StackTrace.current),
        );
      }
    } on AppwriteException catch (e, stackTrace) {
      if (e.code == 404) {
        print(e.toString());
        return left(Failure(
            'Password document not found : ${e.toString()}', stackTrace));
      }
      return left(Failure(e.message ?? 'Unknown Appwrite error', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure('Unexpected error: $e', stackTrace));
    }
  }
}
