import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = await file.readAsString();
    bool changed = false;

    // 1. Fix presentation/theme -> theme/app_theme
    if (content.contains('presentation/theme/theme.dart') || content.contains('../theme/theme.dart')) {
      content = content.replaceAll(RegExp(r"import '.*presentation/theme/theme\.dart';"), "import 'package:jewellary_stock/theme/app_theme.dart';");
      content = content.replaceAll(RegExp(r"import '\.\./theme/theme\.dart';"), "import '../theme/app_theme.dart';");
      content = content.replaceAll(RegExp(r"import '\.\./\.\./theme/theme\.dart';"), "import '../../theme/app_theme.dart';");
      changed = true;
    }

    // 2. Fix presentation/widgets -> widgets
    if (content.contains('presentation/widgets/')) {
      content = content.replaceAll(RegExp(r"import '.*presentation/widgets/(.*)';"), r"import 'package:jewellary_stock/widgets/$1';");
      changed = true;
    }

    // 3. Fix presentation/state -> blocs
    if (content.contains('presentation/state/')) {
      content = content.replaceAll(RegExp(r"import '.*presentation/state/(.*)';"), r"import 'package:jewellary_stock/blocs/$1';");
      changed = true;
    }
    // Also relative ../state/ -> ../blocs/ inside screens
    if (content.contains('../state/')) {
      content = content.replaceAll(RegExp(r"import '\.\./state/(.*)';"), r"import '../blocs/$1';");
      changed = true;
    }
    if (content.contains('../../state/')) {
      content = content.replaceAll(RegExp(r"import '\.\./\.\./state/(.*)';"), r"import '../../blocs/$1';");
      changed = true;
    }

    // 4. Fix domain/entities -> data/models
    // We mapped entity names to model names
    if (content.contains('domain/entities/')) {
      content = content.replaceAll(RegExp(r"import '.*domain/entities/(.*)_entity\.dart';"), r"import 'package:jewellary_stock/data/models/$1_model.dart';");
      content = content.replaceAll(RegExp(r"import '\.\./\.\./domain/entities/(.*)_entity\.dart';"), r"import '../../data/models/$1_model.dart';");
      content = content.replaceAll('CustomerEntity', 'CustomerModel');
      content = content.replaceAll('TransactionEntity', 'TransactionModel');
      content = content.replaceAll('StockEntity', 'StockLedgerEntryModel');
      content = content.replaceAll('UserEntity', 'UserModel');
      content = content.replaceAll('DashboardEntity', 'DashboardSummaryModel');
      changed = true;
    }

    // 5. Replace references to Clean Architecture repositories/usecases with direct bloc/repo
    if (content.contains('domain/usecases/')) {
      // It's dead code if it has domain/usecases, mostly just in dead blocs, but maybe some UI used it? No, UI used blocs.
      // We will just let Dart analyzer tell us if we missed something.
      content = content.replaceAll(RegExp(r"import '.*domain/usecases/.*';\n?"), "");
      changed = true;
    }

    // 6. Fix presentation/screens -> screens
    if (content.contains('presentation/screens/')) {
      content = content.replaceAll(RegExp(r"import '.*presentation/screens/(.*)';"), r"import 'package:jewellary_stock/screens/$1';");
      changed = true;
    }

    if (changed) {
      await file.writeAsString(content);
      print('Fixed ${file.path}');
    }
  }
}
