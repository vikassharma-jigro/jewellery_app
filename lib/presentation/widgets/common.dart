import 'package:flutter/material.dart';
import '../theme/theme.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const SectionCard({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kDivider),
    ),
    child: child,
  );
}

class GoldChip extends StatelessWidget {
  final String label;
  const GoldChip(this.label, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: kGold.withValues(alpha: .15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: kGold.withValues(alpha: .4)),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: kGold,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class StatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => SectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: kGold, size: 18),
            ),
            const Spacer(),
            const Icon(Icons.trending_up, color: kGold, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: kText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
      ],
    ),
  );
}

class BrandHeader extends StatelessWidget {
  final String subtitle;
  const BrandHeader({super.key, this.subtitle = 'Jewellery Ledger'});
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kGold, width: 2),
        ),
        child: const Icon(Icons.diamond, color: kGold, size: 30),
      ),
      const SizedBox(height: 12),
      Text(
        'SORELIAN LEDGER',
        style: TextStyle(
          color: kGold,
          fontSize: 18,
          letterSpacing: 4,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: const TextStyle(color: kMuted, fontSize: 12, letterSpacing: 2),
      ),
    ],
  );
}
