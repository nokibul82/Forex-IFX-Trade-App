import '../models/promo_models.dart';

abstract class PromoRepository {
  Future<List<PromoItem>> getPromotionalCampaigns(String lang);
}