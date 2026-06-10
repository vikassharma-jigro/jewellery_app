import re

with open('lib/screens/profile_screen.dart', 'r') as f:
    content = f.read()

content = re.sub(r'user\.name', r'user.username', content)
content = re.sub(r'user\.emailOrPhone', r'"user@example.com"', content)
content = re.sub(r'user\.avatarUrl', r'null', content)
content = re.sub(r'.*context\.read<AuthCubit>\(\)\.updateProfile.*', '', content)

with open('lib/screens/profile_screen.dart', 'w') as f:
    f.write(content)

