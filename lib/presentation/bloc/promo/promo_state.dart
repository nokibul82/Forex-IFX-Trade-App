part of 'promo_bloc.dart';

abstract class PromoState extends Equatable {
  const PromoState();

  @override
  List<Object> get props => [];
}

class PromoInitial extends PromoState {}

class PromoLoading extends PromoState {}

class PromoLoaded extends PromoState {
  final List<PromoItem> promotions;
  final bool isRefreshing;

  const PromoLoaded({
    required this.promotions,
    this.isRefreshing = false,
  });

  PromoLoaded copyWith({
    List<PromoItem>? promotions,
    bool? isRefreshing,
  }) {
    return PromoLoaded(
      promotions: promotions ?? this.promotions,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [promotions, isRefreshing];
}

class PromoError extends PromoState {
  final String error;

  const PromoError(this.error);

  @override
  List<Object> get props => [error];
}