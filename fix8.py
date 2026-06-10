import re

# dashboard_screen.dart
file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/dashboard_screen.dart"
with open(file, "r") as f:
    content = f.read()

if "import '../state/transaction_cubit.dart';" not in content:
    content = "import '../state/transaction_cubit.dart';\n" + content

with open(file, "w") as f:
    f.write(content)

# market_rate_state.dart
state_file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/state/market_rate_state.dart"
with open(state_file, "r") as f:
    content = f.read()

content = content.replace("final List<dynamic> rates = [];", "final Map<String, dynamic> rates = {};")

with open(state_file, "w") as f:
    f.write(content)

# inventory_screen.dart
inv_file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/inventory_screen.dart"
with open(inv_file, "r") as f:
    content = f.read()

content = content.replace("floatingActionButton:", "fab:")

with open(inv_file, "w") as f:
    f.write(content)

# reports_screen.dart
rep_file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/reports_screen.dart"
with open(rep_file, "r") as f:
    content = f.read()

content = re.sub(r"customer\['(.*?)'\]", r"(customer as dynamic)['\1']", content)
content = content.replace("item['amount']", "(item['amount']?.toString() ?? '0')")
content = content.replace("(item['amount']?.toString() ?? '0')?.toString() ?? '0'", "(item['amount']?.toString() ?? '0')")

with open(rep_file, "w") as f:
    f.write(content)

# customers_screen.dart
cust_file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/customers_screen.dart"
with open(cust_file, "r") as f:
    content = f.read()

content = re.sub(r"customer\['(.*?)'\]", r"(customer as dynamic)['\1']", content)

with open(cust_file, "w") as f:
    f.write(content)
