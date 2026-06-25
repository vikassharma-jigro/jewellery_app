import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../blocs/market/market_rate_cubit.dart';
import '../blocs/market/market_rate_state.dart';

class GoldRateScreen extends StatefulWidget {
  const GoldRateScreen({super.key});

  @override
  State<GoldRateScreen> createState() => _GoldRateScreenState();
}

class _GoldRateScreenState extends State<GoldRateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketRateCubit>().fetchRates();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gold Rate')),
    body: BlocBuilder<MarketRateCubit, MarketRateState>(
      builder: (context, state) {
        if (state is MarketRateLoading || state is MarketRateInitial) {
          return const Center(child: CircularProgressIndicator(color: kGold));
        } else if (state is MarketRateError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: kError)),
          );
        }

        final ratesMap = (state as MarketRateLoaded).rates;
        if (ratesMap.isEmpty) {
          return const Center(
            child: Text(
              'No market rates available',
              style: TextStyle(color: kMuted),
            ),
          );
        }

        final rates = ratesMap.entries
            .map((e) => {'metal': e.key, 'ratePerGram': e.value['ratePerGram']})
            .toList();
        final mainRate = rates.first;
        final mainMetal = mainRate['metal'] ?? 'Unknown Metal';
        final mainPrice = '\$${mainRate['ratePerGram'] ?? 0}';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mainMetal,
                        style: const TextStyle(color: kMuted, fontSize: 12),
                      ),
                      const Spacer(),
                      const GoldChip('LATEST'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mainPrice,
                    style: const TextStyle(
                      color: kGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: kGold,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: kGold.withValues(alpha: .15),
                            ),
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(1, 3.2),
                              FlSpot(2, 3.1),
                              FlSpot(3, 3.6),
                              FlSpot(4, 3.4),
                              FlSpot(5, 3.8),
                              FlSpot(6, 4.1),
                              FlSpot(7, 4.0),
                              FlSpot(8, 4.4),
                              FlSpot(9, 4.3),
                              FlSpot(10, 4.7),
                              FlSpot(11, 4.9),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              child: Column(
                children: rates.map<Widget>((rate) {
                  return Column(
                    children: [
                      _row(
                        rate['metal'].toString(),
                        '\$${rate['ratePerGram']} / g',
                      ),
                      if (rate != rates.last) const Divider(color: kDivider),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Text(k, style: const TextStyle(color: kText)),
        const Spacer(),
        Text(
          v,
          style: const TextStyle(color: kGold, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
