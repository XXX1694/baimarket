import 'package:flutter/material.dart';
import 'package:bai_market/features/my_address/data/models/user_address_model.dart';

class SelectedAddressCard extends StatelessWidget {
  final UserAddressModel address;
  final VoidCallback onClear;
  const SelectedAddressCard({
    super.key,
    required this.address,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Адрес "${address.label}"',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  address.addressLine,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'индекс: ${address.postalCode}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
