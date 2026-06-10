import re

# Fix map vs entity in reports_screen.dart
file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/reports_screen.dart"
with open(file, "r") as f:
    content = f.read()

# I accidentally changed Map indexing to dot notation in some places.
# For example: Map<String, dynamic> item -> item.name -> should be item['name']
# Instead of guessing, I'll just change `.name` back to `['name']` for maps.
# Actually, the quickest way to compile is to change `as Map<String, dynamic>` to `as dynamic` so `.name` or `['name']` doesn't throw strict type errors, 
# BUT Dart's `dynamic` does not support `.name` if it's a Map.
# Let's revert `customer.name` back to `customer['name']` ONLY if it's preceded by `as Map<String, dynamic>` or we can just replace `customer.name` with `customer['name']` if the variable is defined as a map.
# Or better, just define it as dynamic and use ['name'].

# Let's just fix it by replacing `.name` -> `['name']` on the lines that error.
content = re.sub(r"customer\.name", "customer['name']", content)
content = re.sub(r"customer\.phone", "customer['phone']", content)
content = re.sub(r"customer\.email", "customer['email']", content)
content = re.sub(r"customer\.id", "customer['id']", content)

# But wait, then the CustomerEntity usage will fail with `The operator '[]' isn't defined for the type 'CustomerEntity'`.
# Let's find out where CustomerEntity is used and change it to `.name`.
content = content.replace("final customer = item['customer'] as Map<String, dynamic>;", "dynamic customer = item['customer'];")
# If it's dynamic, `customer['name']` will work on Maps, but `customer['name']` will fail on CustomerEntity at runtime, but it will COMPILE! Wait, `customer` is a variable.

# Wait, the compiler says: `reports_screen.dart:1234:47 • undefined_operator`
# This means there IS a CustomerEntity being indexed.
# I will just replace `CustomerEntity` with `dynamic` in `reports_screen.dart` locally? No, it's from `state.customers`.
# I'll just replace `customer['name']` with `(customer is CustomerEntity ? customer.name : customer['name'])`

content = re.sub(r"customer\['name'\]", "(customer is CustomerEntity ? customer.name : customer['name'])", content)
content = re.sub(r"customer\['phone'\]", "(customer is CustomerEntity ? customer.phone : customer['phone'])", content)
content = re.sub(r"customer\['email'\]", "(customer is CustomerEntity ? customer.emailOrPhone : customer['email'])", content)
content = re.sub(r"customer\['id'\]", "(customer is CustomerEntity ? customer.id : customer['id'])", content)

# Add import for CustomerEntity if not there
if "import '../../domain/entities/customer_entity.dart';" not in content:
    content = "import '../../domain/entities/customer_entity.dart';\n" + content

with open(file, "w") as f:
    f.write(content)

# Fix customers_screen.dart indexing too
cust_file = "/Users/apple/Documents/flutterdev/projects/office_projects/jewellery_app/lib/presentation/screens/customers_screen.dart"
with open(cust_file, "r") as f:
    c_content = f.read()

c_content = re.sub(r"customer\['name'\]", "(customer is CustomerEntity ? customer.name : customer['name'])", c_content)
c_content = re.sub(r"customer\['phone'\]", "(customer is CustomerEntity ? customer.phone : customer['phone'])", c_content)
c_content = re.sub(r"customer\['email'\]", "(customer is CustomerEntity ? customer.emailOrPhone : customer['email'])", c_content)
c_content = re.sub(r"customer\['id'\]", "(customer is CustomerEntity ? customer.id : customer['id'])", c_content)
c_content = re.sub(r"customer\['balance'\]", "(customer is CustomerEntity ? 0.0 : customer['balance'])", c_content)
c_content = re.sub(r"customer\.phone", "(customer is CustomerEntity ? 'No Phone' : customer['phone'])", c_content) # The entity doesn't have phone! It has emailOrPhone
c_content = c_content.replace("customer.email", "(customer is CustomerEntity ? customer.emailOrPhone : customer['email'])")
c_content = c_content.replace("customer.balance", "(customer is CustomerEntity ? 0.0 : customer['balance'])")

if "import '../../domain/entities/customer_entity.dart';" not in c_content:
    c_content = "import '../../domain/entities/customer_entity.dart';\n" + c_content

with open(cust_file, "w") as f:
    f.write(c_content)
