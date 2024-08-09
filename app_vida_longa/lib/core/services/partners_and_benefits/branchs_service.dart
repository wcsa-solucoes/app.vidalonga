import 'package:app_vida_longa/core/repositories/partners_and_benefits/branchs_repository.dart';
import 'package:app_vida_longa/domain/models/branch_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBranchsService {
  List<BranchModel> get branchs;
  Future<void> init();
  Future<void> getAllBranchs();
  void selectBranch(BranchModel branch);
  BranchModel get selectedBranch;
}

class BranchsServiceImpl extends IBranchsService {
  BranchsServiceImpl.internal();

  static final IBranchsService _instance = BranchsServiceImpl.internal();

  final IBranchsRepository _branchsRepository =
      BranchsRepositoryImpl(firestore: FirebaseFirestore.instance);

  static IBranchsService get instance => _instance;

  final List<BranchModel> _branchs = [];

  @override
  List<BranchModel> get branchs => _branchs;

  @override
  Future<void> init() async {
    await getAllBranchs();
  }

  @override
  Future<void> getAllBranchs() async {
    final (:response, :branchs) = await _branchsRepository.getAllBranchs();

    if (response.status == ResponseStatusEnum.success) {
      _setBranchs(branchs);
    }
  }

  late BranchModel _selectedBranch;

  @override
  void selectBranch(BranchModel branch) {
    _selectedBranch = branch;
  }

  @override
  BranchModel get selectedBranch => _selectedBranch;

  void _setBranchs(List<BranchModel> branchs) {
    _branchs.clear();
    _branchs.addAll(branchs);
  }
}
