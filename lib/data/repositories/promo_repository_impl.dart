
import 'promo_repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/promo_models.dart';

class PromoRepositoryImpl implements PromoRepository {
  final RemoteDataSource _remoteDataSource;

  PromoRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PromoItem>> getPromotionalCampaigns(String lang) async {
    return await _remoteDataSource.getPromotionalCampaigns(lang);
  }
}