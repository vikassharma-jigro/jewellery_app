import re
import os

def replace_in_file(path, old, new):
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)

replace_in_file('lib/screens/category_summary_screen.dart', 'fetchStock()', 'fetchStockData()')
replace_in_file('lib/screens/category_summary_screen.dart', '.items', '.ledger')
replace_in_file('lib/screens/inventory_screen.dart', 'fetchStock()', 'fetchStockData()')
replace_in_file('lib/screens/inventory_screen.dart', '.stockList', '.ledger')
replace_in_file('lib/screens/new_stock_screen.dart', 'addStock(', '// addStock(')

