import os
import re

lib_dir = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib"

replacements = {
    "../cubits/ledger/ledger_cubit.dart": "../state/transaction_cubit.dart",
    "../cubits/ledger/ledger_state.dart": "../state/transaction_state.dart",
    "../cubits/inventory/inventory_cubit.dart": "../state/stock_cubit.dart",
    "../cubits/inventory/inventory_state.dart": "../state/stock_state.dart",
    "../cubits/customer/customer_cubit.dart": "../state/customer_cubit.dart",
    "../cubits/customer/customer_state.dart": "../state/customer_state.dart",
    "../cubits/audit/audit_cubit.dart": "../state/audit_cubit.dart",
    "../cubits/audit/audit_state.dart": "../state/audit_state.dart",
    "../cubits/market_rate/market_rate_cubit.dart": "../state/market_rate_cubit.dart",
    "../cubits/market_rate/market_rate_state.dart": "../state/market_rate_state.dart",
    "LedgerCubit": "TransactionCubit",
    "LedgerState": "TransactionState",
    "LedgerLoading": "TransactionLoading",
    "LedgerLoaded": "TransactionLoaded",
    "LedgerError": "TransactionError",
    "LedgerInitial": "TransactionInitial",
    "InventoryCubit": "StockCubit",
    "InventoryState": "StockState",
    "InventoryLoading": "StockLoading",
    "InventoryLoaded": "StockLoaded",
    "InventoryError": "StockError",
    "InventoryInitial": "StockInitial",
    "InventoryActionSuccess": "StockLoaded",
    "../the../theme/theme.dart": "../theme/theme.dart",
}

for root, dirs, files in os.walk(os.path.join(lib_dir, "presentation")):
    for file in files:
        if file.endswith(".dart"):
            filepath = os.path.join(root, file)
            with open(filepath, "r") as f:
                content = f.read()
            original_content = content
            for k, v in replacements.items():
                content = content.replace(k, v)
            if content != original_content:
                with open(filepath, "w") as f:
                    f.write(content)
                print(f"Updated {filepath}")
