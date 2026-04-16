import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/shimmer.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/raffle_list_cubit.dart';
import 'raffle_card.dart';

class RafflesListView extends StatefulWidget {
  const RafflesListView({super.key});

  @override
  State<RafflesListView> createState() => _RafflesListViewState();
}

class _RafflesListViewState extends State<RafflesListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<RaffleListCubit>();
      if (cubit.state is RaffleListInitial) cubit.load();
    });
  }

  Future<void> _refresh() => context.read<RaffleListCubit>().load();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<RaffleListCubit, RaffleListState>(
      builder: (context, state) {
        if (state is RaffleListLoaded) {
          if (state.raffles.isEmpty) {
            return _Empty(message: l10n.raffleEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.raffles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  RaffleCard(raffle: state.raffles[index]),
            ),
          );
        }
        if (state is RaffleListError) {
          return _Empty(message: l10n.raffleLoadError);
        }
        return const _Skeleton();
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const SizedBox(
        height: 96,
        child: SimpleShimmer(borderRadius: 16),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
