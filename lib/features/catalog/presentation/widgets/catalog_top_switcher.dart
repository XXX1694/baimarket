import 'package:flutter/material.dart';

enum CatalogTopTab { allShops, wholeCatalog }

class CatalogTopSwitcher extends StatelessWidget {
  const CatalogTopSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.allShopsLabel,
    required this.wholeCatalogLabel,
  });

  final CatalogTopTab selected;
  final ValueChanged<CatalogTopTab> onChanged;
  final String allShopsLabel;
  final String wholeCatalogLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
          ),
          Row(
            children: [
              Expanded(
                child: _Tab(
                  icon: const Text(
                    '🔥',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  label: allShopsLabel,
                  isSelected: selected == CatalogTopTab.allShops,
                  onTap: () => onChanged(CatalogTopTab.allShops),
                ),
              ),
              Expanded(
                child: _Tab(
                  icon: Icon(
                    Icons.grid_view_rounded,
                    size: 18,
                    color:
                        selected == CatalogTopTab.wholeCatalog
                            ? Colors.black
                            : const Color(0xFF9A9A9A),
                  ),
                  label: wholeCatalogLabel,
                  isSelected: selected == CatalogTopTab.wholeCatalog,
                  onTap: () => onChanged(CatalogTopTab.wholeCatalog),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.black : const Color(0xFF9A9A9A),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2,
            color: isSelected ? Colors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
