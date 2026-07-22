#!/usr/bin/env python3
"""Fix all compilation errors in Tweak.x for PXTok v1.1"""

import re

filepath = '/home/z/my-project/Tweak.x'

with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
    content = f.read()

lines = content.split('\n')

# === Fix 1: Remove category syntax from ALL %hook lines ===
# %hook ClassName (CategoryName) → %hook ClassName
for i, line in enumerate(lines):
    m = re.match(r'^%hook\s+(\w+)\s+\(\w+\)', line)
    if m:
        cls_name = m.group(1)
        lines[i] = f'%hook {cls_name}'
        print(f"Line {i+1}: Fixed category syntax -> %hook {cls_name}")

# === Fix 2: Merge BDImageView hooks ===
# First BDImageView hook (line 437-463) has layoutSubviews with profileSave check
# Second BDImageView hook (line 2375-2389) has layoutSubviews that always adds long press
# Merge: change first hook's layoutSubviews to always add, checking for existing gestures
# Then remove the second BDImageView hook entirely

# Find the first BDImageView layoutSubviews body and replace it
first_bd_start = None
first_bd_end = None
second_bd_start = None
second_bd_end = None

for i, line in enumerate(lines):
    if line.strip() == '%hook BDImageView':
        if first_bd_start is None:
            first_bd_start = i
        else:
            second_bd_start = i

# Find %end for each BDImageView
bd_count = 0
for i, line in enumerate(lines):
    if line.strip() == '%hook BDImageView':
        bd_count += 1
    elif line.strip() == '%end' and bd_count > 0:
        if bd_count == 1 and first_bd_end is None:
            first_bd_end = i
        elif bd_count == 2 and second_bd_end is None:
            second_bd_end = i
            bd_count = 0  # reset counter after finding second end

print(f"First BDImageView: lines {first_bd_start+1}-{first_bd_end+1}")
print(f"Second BDImageView: lines {second_bd_start+1}-{second_bd_end+1}")

# Replace first BDImageView layoutSubviews with merged version
# The merged version: always add long press, check for existing gestures first
new_layoutSubviews = '''- (void)layoutSubviews {
    %orig;
    // Always add long press for saving avatar (PXTok v1.1: always enabled)
    BOOL alreadyAdded = NO;
    for (UIGestureRecognizer *gr in self.gestureRecognizers) {
        if ([gr isKindOfClass:[UILongPressGestureRecognizer class]]) {
            alreadyAdded = YES; break;
        }
    }
    if (!alreadyAdded) {
        [self addHandleLongPress];
    }
}'''

# Find and replace the old layoutSubviews in first BDImageView hook
# The old one was: - (void)layoutSubviews { // Profile save ... if ([BHIManager profileSave]) ... }
old_ls_start = first_bd_start + 1  # line after %hook BDImageView
old_ls_end = None
for i in range(old_ls_start, first_bd_end + 1):
    if lines[i].strip() == '%new - (void)addHandleLongPress {':
        old_ls_end = i - 1
        break

if old_ls_end:
    # Replace old layoutSubviews with new merged version
    new_lines_before = lines[:old_ls_start]
    new_lines_after = lines[old_ls_end + 1:]
    merged_ls = new_layoutSubviews.split('\n')
    lines = new_lines_before + merged_ls + new_lines_after
    print(f"Merged BDImageView layoutSubviews at lines {old_ls_start+1}-{old_ls_end+1}")

# Now find and remove the second BDImageView hook (including comments above it)
# Look for the comment block starting with "2. СОХРАНЕНИЕ АВАТАРА"
second_bd_comment_start = None
for i in range(second_bd_start - 1, max(0, second_bd_start - 10), -1):
    if 'СОХРАНЕНИЕ АВАТАРА' in lines[i] or 'сохрание аватара' in lines[i].lower():
        second_bd_comment_start = i
        break
    elif lines[i].strip() == '' and '═══' not in lines[i]:
        continue
    elif '═══' in lines[i]:
        second_bd_comment_start = i
        break

if second_bd_comment_start is None:
    second_bd_comment_start = second_bd_start - 3  # safe fallback

# Recalculate second_bd_end after the merge modification
# Since we modified lines above, second_bd_start and second_bd_end indices may have shifted
# Let's find them again
new_second_bd_start = None
new_second_bd_end = None
bd_count = 0
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped == '%hook BDImageView':
        bd_count += 1
        if bd_count == 2:
            new_second_bd_start = i
    elif stripped == '%end' and bd_count == 2 and new_second_bd_end is None:
        new_second_bd_end = i
        break

print(f"Second BDImageView (after merge): lines {new_second_bd_start+1}-{new_second_bd_end+1}")

# Remove second BDImageView hook + comments
remove_start = second_bd_comment_start if second_bd_comment_start < new_second_bd_start else new_second_bd_start - 3
# Find the comment start (look for ════ line)
for i in range(new_second_bd_start - 1, max(0, new_second_bd_start - 15), -1):
    if '═══' in lines[i]:
        remove_start = i
        break

lines = lines[:remove_start] + lines[new_second_bd_end + 1:]
print(f"Removed second BDImageView hook (lines {remove_start+1}-{new_second_bd_end+1})")

# === Fix 3: Merge AWEAwemeModel initWithDictionary and init ===
# There are multiple %hook AWEAwemeModel blocks with the same method names
# First hook (line ~974): initWithDictionary (hide ads), init (hide ads)
# Duration filter hook (line ~2497): initWithDictionary (duration filter)  
# Word blacklist hook (line ~2513): init (word blacklist)
# We need to merge all into the first hook

# Find all %hook AWEAwemeModel occurrences
awe_hooks = []
awe_count = 0
for i, line in enumerate(lines):
    if line.strip().startswith('%hook AWEAwemeModel'):
        awe_count += 1
        awe_hooks.append({'start': i, 'num': awe_count})

# Find %end for each AWEAwemeModel
hook_depth = 0
current_hook = None
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook') and 'AWEAwemeModel' in stripped:
        hook_depth += 1
        current_hook = awe_hooks[hook_depth - 1]
    elif stripped == '%end' and hook_depth > 0 and current_hook:
        current_hook['end'] = i
        hook_depth -= 1
        current_hook = None

print(f"AWEAwemeModel hooks: {len(awe_hooks)}")
for h in awe_hooks:
    print(f"  Hook #{h['num']}: lines {h['start']+1}-{h['end']+1}")

# We need to:
# 1. Merge initWithDictionary logic from duration filter INTO first hook
# 2. Merge init logic from word blacklist INTO first hook
# 3. Merge isUserRecommendBigCard from PXHideRecommend INTO first hook
# 4. Remove the separate hooks

# Extract the duration filter initWithDictionary method body
dur_hook = awe_hooks[1] if len(awe_hooks) > 1 else None
wl_hook = awe_hooks[2] if len(awe_hooks) > 2 else None
hide_rec_hook = awe_hooks[1] if len(awe_hooks) > 1 else None  # might be same as dur

# Read the content between each hook's start and end
def get_hook_body(hook):
    return '\n'.join(lines[hook['start']:hook['end']+1])

# First, let's modify the first AWEAwemeModel hook's initWithDictionary method
# to combine ads check + duration filter
# Find the initWithDictionary method in the first hook
first_hook = awe_hooks[0]

# Replace the initWithDictionary in first hook with combined logic
combined_initWithDict = '''- (id)initWithDictionary:(id)arg1 error:(id *)arg2 {
    id orig = %orig;
    // PXTok: hide ads
    if ([BHIManager hideAds] && [(AWEAwemeModel *)orig isAds]) return nil;
    if (!orig) return orig;
    // PXTok v1.1: duration filter
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"px_duration_filter_enabled"]) {
        double dur = [[(AWEAwemeModel *)orig video].duration doubleValue] / 1000.0;
        double minD = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_min"] ?: 15;
        double maxD = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_max"] ?: 3600;
        if (dur > 0 && (dur < minD || dur > maxD)) return nil;
    }
    return orig;
}'''

# Replace the init in first hook with combined logic  
combined_init = '''- (id)init {
    id orig = %orig;
    // PXTok: hide ads
    if ([BHIManager hideAds] && [(AWEAwemeModel *)orig isAds]) return nil;
    if (!orig) return orig;
    // PXTok v1.1: word blacklist
    NSArray *blacklist = [[NSUserDefaults standardUserDefaults] arrayForKey:@"px_word_blacklist"];
    if (blacklist.count) {
        NSString *desc = [(AWEAwemeModel *)orig valueForKeyPath:@"descriptionString"] ?:
                         [(AWEAwemeModel *)orig valueForKeyPath:@"desc"] ?:
                         [(AWEAwemeModel *)orig valueForKeyPath:@"videoDescription"] ?: @"";
        NSString *lower = desc.lowercaseString;
        for (NSString *word in blacklist) {
            if ([lower containsString:word.lowercaseString]) return nil;
        }
    }
    return orig;
}'''

# Find and replace initWithDictionary and init in the first AWEAwemeModel hook
# First find the method boundaries
first_hook_body_start = first_hook['start'] + 1  # after %hook line
first_hook_body_end = first_hook['end']  # at %end line

# Find initWithDictionary range in first hook
init_dict_start = None
init_dict_end = None
init_start = None  
init_end = None

for i in range(first_hook_body_start, first_hook_body_end):
    if lines[i].strip().startswith('- (id)initWithDictionary:'):
        init_dict_start = i
    elif init_dict_start and init_dict_end is None:
        if lines[i].strip() == '}' and not any(lines[j].strip().startswith('-') or lines[j].strip().startswith('+') or lines[j].strip().startswith('%') for j in range(init_dict_start+1, i)):
            init_dict_end = i
    
    if lines[i].strip() == '- (id)init {' and init_dict_start is not None:
        init_start = i
    elif init_start and init_end is None:
        # Find closing brace
        if lines[i].strip() == '}':
            init_end = i

print(f"First hook initWithDictionary: lines {init_dict_start+1}-{init_dict_end+1}")
print(f"First hook init: lines {init_start+1}-{init_end+1}")

# Replace initWithDictionary
new_init_dict_lines = combined_initWithDict.split('\n')
lines = lines[:init_dict_start] + new_init_dict_lines + lines[init_dict_end + 1:]

# Adjust indices after replacement
offset = len(new_init_dict_lines) - (init_dict_end - init_dict_start + 1)
init_start += offset
init_end += offset

# Replace init
new_init_lines = combined_init.split('\n')
lines = lines[:init_start] + new_init_lines + lines[init_end + 1:]

offset2 = len(new_init_lines) - (init_end - init_start + 1)
# Adjust all subsequent line references

# Now we need to find and remove the separate AWEAwemeModel hooks
# (PXHideRecommend, PXDurationFilter, PXWordBlacklist)
# Re-find them since indices changed

awe_hooks_v2 = []
awe_count = 0
for i, line in enumerate(lines):
    if line.strip().startswith('%hook AWEAwemeModel'):
        awe_count += 1
        awe_hooks_v2.append({'start': i, 'num': awe_count})

hook_depth = 0
current_hook = None
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook') and 'AWEAwemeModel' in stripped:
        hook_depth += 1
        current_hook = awe_hooks_v2[hook_depth - 1]
    elif stripped == '%end' and hook_depth > 0 and current_hook:
        current_hook['end'] = i
        hook_depth -= 1
        current_hook = None

# Remove hooks 2, 3, 4 (and their preceding comments)
# Work backwards to avoid index shifts
for h in reversed(awe_hooks_v2[1:]):
    # Find comment start above the hook
    comment_start = h['start']
    for i in range(h['start'] - 1, max(0, h['start'] - 15), -1):
        if '═══' in lines[i]:
            comment_start = i
            break
    print(f"Removing AWEAwemeModel hook #{h['num']} (lines {comment_start+1}-{h['end']+1})")
    lines = lines[:comment_start] + lines[h['end'] + 1:]

# === Fix 4: Fix NSInteger receiver type ===
# [[conv conversationType] integerValue] is wrong — conversationType returns NSInteger
# Should be: [conv conversationType] directly
for i, line in enumerate(lines):
    if '[[conv conversationType] integerValue]' in line:
        lines[i] = line.replace('[[conv conversationType] integerValue]', '[conv conversationType]')
        print(f"Line {i+1}: Fixed NSInteger receiver type")

# === Fix 5: Fix sendMessage:succ:fail: call ===
# conv is typed as id but sendMessage:succ:fail: needs to be visible
# Change: [conv sendMessage:message succ:nil fail:nil] 
# to: [(TIMConversation *)conv sendMessage:message succ:nil fail:nil]
for i, line in enumerate(lines):
    if '[conv sendMessage:message succ:nil fail:nil]' in line:
        lines[i] = line.replace('[conv sendMessage:message succ:nil fail:nil]', 
                                '[(TIMConversation *)conv sendMessage:message succ:nil fail:nil]')
        print(f"Line {i+1}: Fixed sendMessage call with cast")

# === Fix 6: Add %new forward declarations via @interface categories ===
# These need to be added BEFORE the %hooks that call them
# We'll add them as ObjC category declarations at the top of the file (after imports)

# Find where #import lines end
import_end = 0
for i, line in enumerate(lines):
    if line.strip().startswith('#import') or line.strip().startswith('#include'):
        import_end = i

declarations = '''
// Forward declarations for %new methods
@interface AWESettingsNormalSectionViewModel (PXTok)
- (void)pxInsertPXTokCellIfNeeded;
@end

@interface AppDelegate (PXTok)
- (void)pxSendStreakMessages;
- (void)pxCheckAndRescheduleStreak;
@end

@interface BDImageView (PXTok)
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end
'''

lines = lines[:import_end + 1] + declarations.split('\n') + lines[import_end + 1:]

# Write the fixed file
with open(filepath, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print("\nAll fixes applied!")
