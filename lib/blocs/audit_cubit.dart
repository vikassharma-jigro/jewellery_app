import 'package:flutter_bloc/flutter_bloc.dart';
import 'audit_state.dart';

class AuditCubit extends Cubit<AuditState> {
  AuditCubit() : super(AuditInitial());

  void fetchAuditLogs() {
    emit(AuditLoading());
    emit(AuditLoaded([]));
  }
}
