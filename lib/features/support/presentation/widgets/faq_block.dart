import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<FAQItem> faqItems = [
      FAQItem(
        question: l10n.faqTicketAfterPayment,
        answer: l10n.faqTicketAfterPaymentAnswer,
      ),
      FAQItem(
        question: l10n.faqDeliveryMethod,
        answer: l10n.faqDeliveryMethodAnswer,
      ),
      FAQItem(
        question: l10n.faqDeliveryTime,
        answer: l10n.faqDeliveryTimeAnswer,
      ),
      FAQItem(question: l10n.faqCancelOrder, answer: l10n.faqCancelOrderAnswer),
      FAQItem(question: l10n.faqTrackOrder, answer: l10n.faqTrackOrderAnswer),
    ];

    return ListView.builder(
      itemCount: faqItems.length,
      itemBuilder: (context, index) {
        final item = faqItems[index];
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Text(
              item.question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Text(
                  item.answer,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
