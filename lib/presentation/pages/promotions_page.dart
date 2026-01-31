import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/promo/promo_bloc.dart';
import '../widgets/promo_card.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromoBloc>().add(LoadPromotions());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotional Campaigns'),
        actions: [
          BlocBuilder<PromoBloc, PromoState>(
            builder: (context, state) {
              if (state is PromoLoaded && state.isRefreshing) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PromoBloc>().add(RefreshPromotions());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PromoBloc, PromoState>(
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PromoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.error,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PromoBloc>().add(LoadPromotions());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PromoLoaded) {
            if (state.promotions.isEmpty) {
              return const Center(
                child: Text(
                  'No promotional campaigns available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PromoBloc>().add(RefreshPromotions());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: state.promotions.length,
                itemBuilder: (context, index) {
                  return PromoCard(promo: state.promotions[index]);
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}