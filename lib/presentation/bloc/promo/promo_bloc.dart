import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../data/models/promo_models.dart';
import '../../../data/repositories/promo_repository.dart';


part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository _promoRepository;

  PromoBloc(this._promoRepository) : super(PromoInitial()) {
    on<LoadPromotions>(_onLoadPromotions);
    on<RefreshPromotions>(_onRefreshPromotions);
  }

  Future<void> _onLoadPromotions(
      LoadPromotions event,
      Emitter<PromoState> emit,
      ) async {
    emit(PromoLoading());
    print("_onLoadPromotions() called");
    try {
      final promotions = await _promoRepository.getPromotionalCampaigns('en');
      emit(PromoLoaded(promotions: promotions));
    } on NetworkException catch (e) {
      emit(PromoError('Network error: ${e.message}'));
    } on ServerException catch (e) {
      emit(PromoError('Server error: ${e.message}'));
    } catch (e) {
      emit(PromoError('Failed to load promotional campaigns'));
    }
  }

  Future<void> _onRefreshPromotions(
      RefreshPromotions event,
      Emitter<PromoState> emit,
      ) async {
    if (state is PromoLoaded) {
      emit((state as PromoLoaded).copyWith(isRefreshing: true));
    }

    try {
      final promotions = await _promoRepository.getPromotionalCampaigns('en');
      emit(PromoLoaded(promotions: promotions));
    } on NetworkException catch (e) {
      emit(PromoError('Network error: ${e.message}'));
    } on ServerException catch (e) {
      emit(PromoError('Server error: ${e.message}'));
    } catch (e) {
      emit(PromoError('Failed to refresh promotional campaigns'));
    }
  }
}