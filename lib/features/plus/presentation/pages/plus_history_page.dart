import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

const Color _kPlusPurple = Color(0xFF7479E5);
const Color _kPageBg = Color(0xFF1A1A1A);
const Color _kCardBg = Color(0xFF363636);
const Color _kSecondaryText = Color(0xFFA0A0A0);

class _HistoryEntry {
  const _HistoryEntry({
    required this.title,
    required this.dateLabel,
    required this.amountLabel,
  });
  final String title;
  final String dateLabel;
  final String amountLabel;
}

class _HistorySection {
  const _HistorySection({required this.month, required this.entries});
  final String month;
  final List<_HistoryEntry> entries;
}

const List<_HistorySection> _mockSections = [
  _HistorySection(
    month: 'Март',
    entries: [
      _HistoryEntry(
        title: 'Plus-подписка',
        dateLabel: 'Списано 24 марта',
        amountLabel: '-2 900 KZT',
      ),
      _HistoryEntry(
        title: 'Plus-подписка',
        dateLabel: 'Списано 24 марта',
        amountLabel: '-2 900 KZT',
      ),
    ],
  ),
  _HistorySection(
    month: 'Апрель',
    entries: [
      _HistoryEntry(
        title: 'Plus-подписка',
        dateLabel: 'Списано 24 марта',
        amountLabel: '-2 900 KZT',
      ),
      _HistoryEntry(
        title: 'Plus-подписка',
        dateLabel: 'Списано 24 марта',
        amountLabel: '-2 900 KZT',
      ),
    ],
  ),
];

class PlusHistoryPage extends StatelessWidget {
  const PlusHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _kPageBg,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 18),
              for (final section in _mockSections) ...[
                _SectionHeader(text: section.month),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (int i = 0; i < section.entries.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        _HistoryItem(entry: section.entries[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kPageBg,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackCircleButton(onPressed: () => context.pop()),
          const SizedBox(height: 22),
          const Text(
            'История списаний',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Тут вся информация за\nпоследние полгода',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  const _BackCircleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(40, 40),
      onPressed: onPressed,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF3A3A3A),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 16, 0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _kSecondaryText,
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.entry});
  final _HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _PlusAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.dateLabel,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _kSecondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.amountLabel,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusAvatar extends StatelessWidget {
  const _PlusAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: _kPlusPurple,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'P',
        style: TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          color: Colors.white,
        ),
      ),
    );
  }
}
