import re

with open(r'D:\Henok\Projects\Game\extracted_game_data\lua_scripts\net\proto_require.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

matches = re.findall(r'assert\(Dll_PB\.load\(mono\.LoadProtoPB\("([^"]+)"\)\)', text)
print(f'Total active PB schemas loaded: {len(matches)}')
for m in matches[:15]:
    print(f'  {m}')
