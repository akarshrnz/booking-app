import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/data/models/branch_model.dart';

abstract class BranchRemoteDataSource {
  Future<List<BranchModel>> getBranches();
  Future<List<BranchModel>> searchBranches(String query);
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  BranchRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<List<BranchModel>> getBranches() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.branchesCollection)
          .get();

      return snapshot.docs
          .map((doc) => BranchModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  @override
  Future<List<BranchModel>> searchBranches(String query) async {
    try {
      final nameSnapshot = await firestore
          .collection(AppConstants.branchesCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      final citySnapshot = await firestore
          .collection(AppConstants.branchesCollection)
          .where('city', isEqualTo: query)
          .get();

      final combinedDocs = [...nameSnapshot.docs, ...citySnapshot.docs];
      final uniqueDocs = {
        for (var doc in combinedDocs) doc.id: doc
      }.values.toList(); // removes duplicates

      return uniqueDocs
          .map((doc) => BranchModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(message: e.message ?? 'Firestore error');
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
