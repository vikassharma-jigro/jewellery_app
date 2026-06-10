import re
import os

def replace_in_file(path, old, new):
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)

replace_in_file('lib/screens/category_summary_screen.dart', 'fetchInventory()', 'fetchStock()')
replace_in_file('lib/screens/inventory_screen.dart', "import '../blocs/stock_state.dart';", "import '../blocs/stock_cubit.dart';")
replace_in_file('lib/screens/inventory_screen.dart', 'loadStockData()', 'fetchStock()')
replace_in_file('lib/screens/inventory_screen.dart', '.balance', '.stockList')
replace_in_file('lib/screens/item_details_screen.dart', 'kCardHighest', 'kCard2')
replace_in_file('lib/screens/new_stock_screen.dart', "import '../blocs/stock_state.dart';", "import '../blocs/stock_cubit.dart';")
replace_in_file('lib/screens/new_stock_screen.dart', '.message', '.toString()')
replace_in_file('lib/screens/new_stock_screen.dart', 'addItem', 'addStock')
replace_in_file('lib/screens/profile_screen.dart', "import '../blocs/auth_state.dart';", "import '../blocs/auth_cubit.dart';")

