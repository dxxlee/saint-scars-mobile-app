// lib/frontend/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc         = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            iconPath: 'assets/icons/Shop.svg',
            label:   loc.navHome,
            index:   0,
            context: context,
          ),
          _buildNavItem(
            iconPath: 'assets/icons/Stores.svg',
            label:   loc.navClothes,
            index:   1,
            context: context,
          ),
          _buildNavItem(
            iconPath: 'assets/icons/Bag.svg',
            label:   loc.navCart,
            index:   2,
            context: context,
          ),
          _buildNavItem(
            iconPath: 'assets/icons/Order.svg',
            label:   loc.navOrders,
            index:   3,
            context: context,
          ),
          _buildNavItem(
            iconPath: 'assets/icons/Profile.svg',
            label:   loc.navAccount,
            index:   4,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final bool isSelected = index == currentIndex;
    final colorScheme     = Theme.of(context).colorScheme;
    final iconColor       = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 28,
            height: 28,
            color: iconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
