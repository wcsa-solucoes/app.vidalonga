import 'package:app_vida_longa/core/repositories/partners_and_benefits/partner_companies_repository.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPartnerService {
  List<PartnerCompanyModel> get partnerCompanies;
  Future<void> init();
  Future<void> getPartnerCompanies();
  void selectPartner(PartnerCompanyModel partner);
  PartnerCompanyModel get selectedPartner;
}

class PartnerServiceImpl extends IPartnerService {
  PartnerServiceImpl.internal();

  static final IPartnerService _instance = PartnerServiceImpl.internal();

  static IPartnerService get instance => _instance;

  final IPartnerCompaniesRepository _partnerCompaniesRepository =
      PartnerCompaniesRepositoryImpl(firestore: FirebaseFirestore.instance);

  final List<PartnerCompanyModel> _partnerCompanies = [];

  @override
  List<PartnerCompanyModel> get partnerCompanies => _partnerCompanies;

  @override
  Future<void> init() async {
    await getPartnerCompanies();
  }

  @override
  Future<void> getPartnerCompanies() async {
    final response = await _partnerCompaniesRepository.getAllPartners();

    if (response.response.status == ResponseStatusEnum.success) {
      _setPartnerCompanies(response.partnerCompanies);
    }
  }

  void _setPartnerCompanies(List<PartnerCompanyModel> partnerCompanies) {
    _partnerCompanies.clear();
    _partnerCompanies.addAll(partnerCompanies);
  }

  late PartnerCompanyModel _selectedPartner;

  @override
  void selectPartner(PartnerCompanyModel partner) {
    _selectedPartner = partner;
  }

  @override
  PartnerCompanyModel get selectedPartner => _selectedPartner;
}
