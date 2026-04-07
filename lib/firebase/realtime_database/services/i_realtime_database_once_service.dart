import 'package:firebase_database/firebase_database.dart';

import '../objects/db_reference_path.dart';

/// Interface for performing one-time reads from Firebase Realtime Database.
abstract class IFirebaseRealtimeDatabaseOnceService {
  const IFirebaseRealtimeDatabaseOnceService();

  FirebaseDatabase get db => FirebaseDatabase.instance;

  Future<DataSnapshot> get(IFirebaseDbReferencePath path);
}
