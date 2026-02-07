import 'package:flutter/material.dart';

/// Barre de navigation latérale avec grandes icônes (style wellness)
class SideNavRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<({IconData icon, IconData selectedIcon, String label})> items;

  const SideNavRail({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  static const double _iconSize = 48;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unselectedColor = scheme.onSurface.withOpacity(0.7);
    final selectedColor = scheme.primary;
    final destinations = items
        .map(
          (item) => NavigationRailDestination(
            icon: Icon(item.icon, size: _iconSize, color: unselectedColor),
            selectedIcon: Icon(item.selectedIcon, size: _iconSize, color: selectedColor),
            label: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        )
        .toList();

    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(4, 0),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationRail(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
          extended: false,
          minWidth: 96,
          backgroundColor: Colors.transparent,
          indicatorColor: scheme.primaryContainer.withOpacity(0.7),
          labelType: NavigationRailLabelType.all,
        ),
      ),
    );
  }
}
