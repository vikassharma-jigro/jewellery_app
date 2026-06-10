import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../theme/theme.dart';
import '../widgets/common.dart';
import '../state/audit_cubit.dart';
import '../state/audit_state.dart';

class AuditTrailScreen extends StatefulWidget {
  const AuditTrailScreen({super.key});

  @override
  State<AuditTrailScreen> createState() => _AuditTrailScreenState();
}

class _AuditTrailScreenState extends State<AuditTrailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuditCubit>().fetchAuditLogs();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Audit Trail')),
    body: BlocBuilder<AuditCubit, AuditState>(
      builder: (context, state) {
        if (state is AuditLoading || state is AuditInitial) {
          return const Center(child: CircularProgressIndicator(color: kGold));
        } else if (state is AuditError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: kError)),
          );
        }

        final logs = (state as AuditLoaded).logs;

        if (logs.isEmpty) {
          return const Center(
            child: Text('No audit logs found', style: TextStyle(color: kMuted)),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: logs.map((l) {
            final action = l['action'] ?? 'Unknown Action';
            final details = l['details'] ?? 'No details provided';
            final timestamp = l['timestamp'] != null
                ? DateFormat('hh:mm a').format(DateTime.parse(l['timestamp']))
                : 'Unknown Time';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: const BoxDecoration(
                        color: kGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action,
                            style: const TextStyle(
                              color: kText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            details,
                            style: const TextStyle(color: kMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        color: kGold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    ),
  );
}
