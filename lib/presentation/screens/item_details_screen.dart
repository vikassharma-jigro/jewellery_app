import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/common.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemName;
  final String sku;
  final String valuation;
  final String category;
  final String qty;
  final String status;

  const ItemDetailsScreen({
    super.key,
    this.itemName = 'Celestial Cascade Diamond Necklace',
    this.sku = 'AL-DX-2024-001402',
    this.valuation = '\$142,850.00',
    this.category = 'HIGH JEWELRY',
    this.qty = '1 unit',
    this.status = 'Vaulted & Secure',
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  bool _isFavorite = false;
  int _activeImageIndex = 0;

  final List<String> _images = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA9QPNEbxssa-Hstua3rVcY3l3lNLlldQmEz0SAMNMGmba2iZDNaze0lnElJ1AYsVztkLRrkjravDpFRwBPXsI6Vyp0XanRn7Oid9zbXKylGnDnWdSeH7xAKHMbehJU1NQknFTgZZdLzMLclvgj7xOdHSl-QpGt6q3AM2_EJ6tcbRXXU6UHspo8HbMBYMA8yawtovyM41WkBACgCf644eqWdvg-RLCYLbWnbfNdo7bj-UedLmmYqe5iJXq_x_vhURkTQDuJTxCT5kUC',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBdaooMs1ckpxKsIB_c3EfzZi4KuEp98AqHFuDa0hbd71g0MkIQ1_nBsJg8L5d6lCPMcV3eU-CCNlBXEAQZKfQ3Xuag2VW98-0HGY2-cPCz99fmgxG-Q00MGcL_XGu0Wku9GqR3WRbqseOiwnwltx9iCgqXUcHg8eSLC8IX1xZnbPUxHT5F4wfO9sy2cMoX96MG8UUwDZyfEtfL_9MfsdHadzS6A6A3ZJ8cmYOiKzxuXWmFAG7Yo2hgE0vMUbMmAGDwcf8yBR45W8mX',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDNGRsX7lAaMW8ZbAZkSeDFpn6zELZZf4Moe6svkygDlUf-lfM_df78bmKvqZ0alKX_vGnr5DF1vq4c2koGIeKUkpZCxH0cZeM9UWMddlpwsb3CAU3gpE9PE9EmLP1l-ALhtkQnCyaFHAYze0Ao8xTumt5t338QbGfe9V9oXw_D7BGKh2j4eSY6asoxNzv2QKyS_R4rgv73r420Ys_lP-p0PtxhlgyAuiYVnertEIcne_Ua2W7hI26NeqBzIy8xg7K1_0o3bGdaURtM',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: kCard2,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: kDivider.withValues(alpha: 0.2), width: 1),
        ),
        title: const Text(
          'Asset Details',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kGold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Breadcrumbs
              _buildBreadcrumb(context),
              const SizedBox(height: 24),

              // Two Column Layout for Desktop
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildProductHero(size)),
                    const SizedBox(width: 32),
                    Expanded(flex: 5, child: _buildProductInformation(context)),
                  ],
                )
              else ...[
                _buildProductHero(size),
                const SizedBox(height: 24),
                _buildProductInformation(context),
              ],
              const SizedBox(height: 40),

              // Transaction / Audit Ledger History
              _buildAuditLedgerSection(isDesktop),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Stock',
              style: TextStyle(fontSize: 12, color: kMuted),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.chevron_right,
            size: 14,
            color: kMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 6),
          const Text(
            'High Jewelry',
            style: TextStyle(fontSize: 12, color: kMuted),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.chevron_right,
            size: 14,
            color: kMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 6),
          Text(
            widget.sku.split('-').last,
            style: const TextStyle(
              fontSize: 12,
              color: kGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHero(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Large Image Container
        Container(
          height: size.width > 600 ? 450 : 320,
          decoration: BoxDecoration(
            color: kCard2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDivider.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                _images[_activeImageIndex],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.diamond, size: 64, color: kGold),
              ),

              // Action overlays (fullscreen, zoom)
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildGlassIconButton(Icons.fullscreen),
                    const SizedBox(height: 8),
                    _buildGlassIconButton(Icons.zoom_in),
                  ],
                ),
              ),

              // Secure location badge overlay
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kCard.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kDivider.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: kText,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Thumbnail strip
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isSelected = _activeImageIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeImageIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? kGold
                          : kDivider.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Opacity(
                    opacity: isSelected ? 1.0 : 0.6,
                    child: Image.network(
                      _images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: kCardHigh),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlassIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: kCard.withValues(alpha: 0.7),
        shape: BoxShape.circle,
        border: Border.all(color: kGold.withValues(alpha: 0.15)),
      ),
      child: Icon(icon, color: kText, size: 20),
    );
  }

  Widget _buildProductInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name and Favorite
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.itemName,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${widget.sku}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: kMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.redAccent : kMuted,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Valuation block
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDivider.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CURRENT MARKET VALUATION',
                    style: TextStyle(
                      fontSize: 10,
                      color: kMuted,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.trending_up,
                        color: Colors.greenAccent,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '+4.2%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.valuation,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kGold,
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useRow = constraints.maxWidth > 340;
                  final transferBtn = SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGold,
                        foregroundColor: const Color(0xFF241A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.sync_alt, size: 16),
                      label: const Text(
                        'Transfer Asset',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  );

                  final updateBtn = SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kGold,
                        side: const BorderSide(color: kGold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.update, size: 16),
                      label: const Text(
                        'Update Rates',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  );

                  if (useRow) {
                    return Row(
                      children: [
                        Expanded(child: transferBtn),
                        const SizedBox(width: 12),
                        Expanded(child: updateBtn),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        transferBtn,
                        const SizedBox(height: 12),
                        updateBtn,
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Core specs
        const Text(
          'CORE SPECIFICATIONS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: kMuted,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kDivider.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSpecCell('Total Weight', '42.50 Grams'),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: kDivider.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _buildSpecCell('Gold Purity', '18K White Gold'),
                  ),
                ],
              ),
              Divider(color: kDivider.withValues(alpha: 0.2), height: 1),
              Row(
                children: [
                  Expanded(
                    child: _buildSpecCell('Stone Detail', '12.2ct Diamonds'),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: kDivider.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _buildSpecCell('Clarity/Color', 'VVS1 | D-Color'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            GoldChip('GIA Certified'),
            GoldChip('Conflict Free'),
            GoldChip('Investment Grade'),
          ],
        ),
        const SizedBox(height: 24),

        // Cert & Vault Details
        Row(
          children: [
            Expanded(
              child: _buildDetailsCard(
                icon: Icons.verified_user_outlined,
                title: 'GIA-22849102',
                subtitle: 'View Certificate',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailsCard(
                icon: Icons.location_on_outlined,
                title: 'Vault Sect. B-12',
                subtitle: 'Physical Location',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // QR Code tracking box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kGold.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kGold.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              // Mock QR code design
              Container(
                width: 60,
                height: 60,
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: GridView.count(
                  crossAxisCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(36, (index) {
                    final isBlack =
                        (index % 3 == 0) ||
                        (index % 5 == 1 && index > 12) ||
                        (index < 6 ||
                            index % 6 == 0 ||
                            index % 6 == 5 ||
                            index > 30);
                    return Container(
                      color: isBlack ? Colors.black : Colors.white,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Vault Tracking ID',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'AUR-NFT-39281-00',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: kMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Download ID',
                  style: TextStyle(
                    color: kGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecCell(String label, String value) {
    return Container(
      color: kCard2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 9, color: kMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: kText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kCardHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: kGold, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(fontSize: 9, color: kMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLedgerSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Asset Audit Ledger',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kDivider.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: isDesktop
              ? Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.2),
                    1: FlexColumnWidth(2.0),
                    2: FlexColumnWidth(2.0),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(0.6),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(
                        color: kCardHigh.withValues(alpha: 0.5),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'DATE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kMuted,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'ACTIVITY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kMuted,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'ENTITY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kMuted,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'VALUE (USD)',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kMuted,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'ACTION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Body row 1
                    _buildAuditRow(
                      date: 'Oct 24, 2023',
                      activity: 'Valuation Increase',
                      entity: 'Automated Market Sync',
                      value: '\$142,850.00',
                      isActiveColor: kGold,
                    ),
                    // Body row 2
                    _buildAuditRow(
                      date: 'Aug 12, 2023',
                      activity: 'Physical Audit',
                      entity: 'M. Aurelius (Overseer)',
                      value: '\$137,100.00',
                      isActiveColor: kMuted,
                    ),
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMobileAuditCard(
                      date: 'Oct 24, 2023',
                      activity: 'Valuation Increase',
                      entity: 'Automated Market Sync',
                      value: '\$142,850.00',
                      isActiveColor: kGold,
                    ),
                    Divider(color: kDivider.withValues(alpha: 0.1), height: 1),
                    _buildMobileAuditCard(
                      date: 'Aug 12, 2023',
                      activity: 'Physical Audit',
                      entity: 'M. Aurelius (Overseer)',
                      value: '\$137,100.00',
                      isActiveColor: kMuted,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildMobileAuditCard({
    required String date,
    required String activity,
    required String entity,
    required String value,
    required Color isActiveColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, color: kMuted)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActiveColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                activity,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(entity, style: const TextStyle(fontSize: 12, color: kMuted)),
        ],
      ),
    );
  }

  TableRow _buildAuditRow({
    required String date,
    required String activity,
    required String entity,
    required String value,
    required Color isActiveColor,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kDivider.withValues(alpha: 0.1), width: 1),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(date, style: const TextStyle(fontSize: 13, color: kText)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActiveColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                activity,
                style: const TextStyle(fontSize: 13, color: kText),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            entity,
            style: const TextStyle(fontSize: 13, color: kMuted),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Icon(Icons.more_horiz, color: kMuted, size: 18),
        ),
      ],
    );
  }
}
