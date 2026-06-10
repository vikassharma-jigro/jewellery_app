import os
import re

lib_dir = 'lib'

for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if not file.endswith('.dart'):
            continue
        filepath = os.path.join(root, file)
        
        with open(filepath, 'r') as f:
            content = f.read()
            
        original_content = content
        
        # 1. Fix presentation/theme -> theme/app_theme
        content = re.sub(r"import '.*presentation/theme/theme\.dart';", r"import 'package:jewellary_stock/theme/app_theme.dart';", content)
        content = re.sub(r"import '\.\./theme/theme\.dart';", r"import '../theme/app_theme.dart';", content)
        content = re.sub(r"import '\.\./\.\./theme/theme\.dart';", r"import '../../theme/app_theme.dart';", content)

        # 2. Fix presentation/widgets -> widgets
        content = re.sub(r"import '.*presentation/widgets/(.*?)';", r"import 'package:jewellary_stock/widgets/\1';", content)

        # 3. Fix presentation/state -> blocs
        content = re.sub(r"import '.*presentation/state/(.*?)';", r"import 'package:jewellary_stock/blocs/\1';", content)
        content = re.sub(r"import '\.\./state/(.*?)';", r"import '../blocs/\1';", content)
        content = re.sub(r"import '\.\./\.\./state/(.*?)';", r"import '../../blocs/\1';", content)

        # 4. Fix domain/entities -> data/models
        content = re.sub(r"import '.*domain/entities/(.*?)_entity\.dart';", r"import 'package:jewellary_stock/data/models/\1_model.dart';", content)
        content = re.sub(r"import '\.\./\.\./domain/entities/(.*?)_entity\.dart';", r"import '../../data/models/\1_model.dart';", content)
        
        content = content.replace('CustomerEntity', 'CustomerModel')
        content = content.replace('TransactionEntity', 'TransactionModel')
        content = content.replace('StockEntity', 'StockLedgerEntryModel')
        content = content.replace('UserEntity', 'UserModel')
        content = content.replace('DashboardEntity', 'DashboardSummaryModel')

        # 5. Fix presentation/screens -> screens
        content = re.sub(r"import '.*presentation/screens/(.*?)';", r"import 'package:jewellary_stock/screens/\1';", content)

        # 6. Remove dead usecase imports
        content = re.sub(r"import '.*domain/usecases/.*?';\n?", "", content)

        if content != original_content:
            with open(filepath, 'w') as f:
                f.write(content)
            print(f'Fixed {filepath}')

