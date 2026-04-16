import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/cards_cubit.dart';
import '../widgets/card_tile.dart';
import '../widgets/cards_empty_state.dart';

class MyCardsPage extends StatelessWidget {
  const MyCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardsCubit(),
      child: const _MyCardsView(),
    );
  }
}

class _MyCardsView extends StatelessWidget {
  const _MyCardsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () => context.pop(),
                    child: SvgPicture.asset(
                      'assets/icons/arrow_left.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: Text(
                          l10n.myCards,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: BlocBuilder<CardsCubit, CardsState>(
                builder: (context, state) {
                  final cards = (state as CardsLoaded).cards;
                  if (cards.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 20),
                      child: CardsEmptyState(
                        onAdd: () =>
                            context.read<CardsCubit>().addMockCard(),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 20),
                    itemCount: cards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return CardTile(
                        card: card,
                        onRemove: () => context
                            .read<CardsCubit>()
                            .removeCard(card.id),
                      );
                    },
                  );
                },
              ),
            ),

            // Sticky bottom add button (only when list is non-empty)
            BlocBuilder<CardsCubit, CardsState>(
              builder: (context, state) {
                final cards = (state as CardsLoaded).cards;
                if (cards.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          context.read<CardsCubit>().addMockCard(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainColorLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.addCard,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
