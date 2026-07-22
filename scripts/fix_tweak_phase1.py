#!/usr/bin/env python3
"""Fix Tweak.x compilation errors — simple and reliable approach"""

filepath = '/home/z/my-project/Tweak.x'
with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
    content = f.read()

# === Fix 1: Remove ALL category syntax from %hook lines ===
import re
content = re.sub(r'%hook\s+(\w+)\s+\(\w+\)', r'%hook \1', content)

# === Fix 2: Fix NSInteger receiver type ===
content = content.replace('[[conv conversationType] integerValue]', '[conv conversationType]')

# === Fix 3: Fix sendMessage call with cast ===
content = content.replace('[conv sendMessage:message succ:nil fail:nil]', 
                          '[(TIMConversation *)conv sendMessage:message succ:nil fail:nil]')

# === Fix 4: Add forward declarations for %new methods at top ===
# Find first %hook line and insert declarations before it
declarations = """// Forward declarations for %new methods (needed by ARC compiler)
@interface AWESettingsNormalSectionViewModel (PXTok)
- (void)pxInsertPXTokCellIfNeeded;
@end

@interface AppDelegate (PXTok)
- (void)pxSendStreakMessages;
- (void)pxCheckAndRescheduleStreak;
@end

@interface BDImageView (PXTok)
- (void)addHandleLongPress;
@end

"""

first_hook_pos = content.find('%hook ')
if first_hook_pos > 0:
    content = content[:first_hook_pos] + declarations + content[first_hook_pos:]

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Phase 1 done: category syntax + NSInteger + sendMessage + forward declarations")
