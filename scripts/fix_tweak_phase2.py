#!/usr/bin/env python3
"""Phase 2: Merge duplicate BDImageView and AWEAwemeModel hooks"""

filepath = '/home/z/my-project/Tweak.x'
with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
    lines = f.readlines()

# === Find all hooks and their boundaries ===
hooks = []
depth = 0
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook '):
        cls = stripped.split()[1] if len(stripped.split()) > 1 else stripped
        hooks.append({'start': i, 'class': cls, 'depth_at_start': depth})
        depth += 1
    elif stripped == '%end':
        depth -= 1
        if depth == 0 or (hooks and hooks[-1].get('end') is None):
            # Find the most recent hook without an end
            for h in reversed(hooks):
                if 'end' not in h:
                    h['end'] = i
                    break

print("All hooks:")
for h in hooks:
    cls = h['class']
    print(f"  {cls}: lines {h['start']+1}-{h['end']+1}")

# === Find duplicate BDImageView hooks ===
bd_hooks = [h for h in hooks if h['class'] == 'BDImageView']
print(f"\nBDImageView hooks: {len(bd_hooks)}")

if len(bd_hooks) >= 2:
    # Merge: modify first hook's layoutSubviews, remove second hook
    first_bd = bd_hooks[0]
    second_bd = bd_hooks[1]
    
    # Find the layoutSubviews method in first BDImageView hook
    first_bd_body = lines[first_bd['start']:first_bd['end']+1]
    
    # Find old layoutSubviews (the profileSave-toggle version)
    ls_start = None
    ls_end = None
    for j, line in enumerate(first_bd_body):
        if '- (void)layoutSubviews' in line:
            ls_start = first_bd['start'] + j
        elif ls_start and ls_end is None and line.strip() == '}':
            # Check if this is the closing brace of layoutSubviews
            # Look ahead to find next method declaration
            next_is_method = False
            for k in range(j+1, len(first_bd_body)):
                s = first_bd_body[k].strip()
                if s.startswith('-') or s.startswith('+') or s.startswith('%') or s == '%end':
                    next_is_method = True
                    break
                elif s == '}':
                    continue
                elif s == '' or s.startswith('//'):
                    continue
                else:
                    break
            if next_is_method:
                ls_end = first_bd['start'] + j
    
    print(f"First BDImageView layoutSubviews: lines {ls_start+1}-{ls_end+1}")
    
    # Replace with merged version that always adds long press
    merged_ls = """- (void)layoutSubviews {
    %orig;
    // PXTok: always add long press for avatar saving
    BOOL alreadyAdded = NO;
    for (UIGestureRecognizer *gr in self.gestureRecognizers) {
        if ([gr isKindOfClass:[UILongPressGestureRecognizer class]]) {
            alreadyAdded = YES; break;
        }
    }
    if (!alreadyAdded) {
        [self addHandleLongPress];
    }
}"""
    
    merged_ls_lines = merged_ls.split('\n')
    lines = lines[:ls_start] + [l + '\n' for l in merged_ls_lines] + lines[ls_end+1:]
    
    # Now find and remove the second BDImageView hook (and its preceding comments)
    # Re-find hooks since line indices changed
    print("Re-scanning after BDImageView merge...")
    
# === Re-scan all hooks after modifications ===
hooks2 = []
depth = 0
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook '):
        cls = stripped.split()[1] if len(stripped.split()) > 1 else stripped
        hooks2.append({'start': i, 'class': cls})
        depth += 1
    elif stripped == '%end':
        depth -= 1
        for h in reversed(hooks2):
            if 'end' not in h:
                h['end'] = i
                break

bd_hooks2 = [h for h in hooks2 if h['class'] == 'BDImageView']
if len(bd_hooks2) >= 2:
    second_bd = bd_hooks2[1]
    # Find comment block above second BDImageView
    comment_start = second_bd['start']
    for i in range(second_bd['start'] - 1, max(0, second_bd['start'] - 20), -1):
        if '═══' in lines[i] or 'СОХРАНЕНИЕ АВАТАРА' in lines[i]:
            comment_start = i
            break
        elif lines[i].strip() == '' and '═══' not in lines[i]:
            continue
        elif lines[i].strip().startswith('//') and '═══' not in lines[i]:
            continue
        else:
            comment_start = i + 1
            break
    
    print(f"Removing second BDImageView (lines {comment_start+1}-{second_bd['end']+1})")
    lines = lines[:comment_start] + lines[second_bd['end']+1:]

# === Handle duplicate AWEAwemeModel hooks ===
# Re-scan after BDImageView removal
hooks3 = []
depth = 0
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook '):
        cls = stripped.split()[1] if len(stripped.split()) > 1 else stripped
        hooks3.append({'start': i, 'class': cls})
        depth += 1
    elif stripped == '%end':
        depth -= 1
        for h in reversed(hooks3):
            if 'end' not in h:
                h['end'] = i
                break

awe_hooks3 = [h for h in hooks3 if h['class'] == 'AWEAwemeModel']
print(f"\nAWEAwemeModel hooks: {len(awe_hooks3)}")

if len(awe_hooks3) >= 2:
    first_awe = awe_hooks3[0]
    
    # Modify first hook's initWithDictionary to combine ads + duration filter
    body_start = first_awe['start'] + 1
    body_end = first_awe['end']
    
    # Find initWithDictionary in first hook
    id_start = None
    id_end = None
    for j in range(body_start, body_end + 1):
        if lines[j].strip().startswith('- (id)initWithDictionary:'):
            id_start = j
        elif id_start and id_end is None and lines[j].strip() == '}':
            id_end = j
    
    if id_start and id_end:
        print(f"First AWEAwemeModel initWithDictionary: lines {id_start+1}-{id_end+1}")
        new_id = """- (id)initWithDictionary:(id)arg1 error:(id *)arg2 {
    id orig = %orig;
    if ([BHIManager hideAds] && [(AWEAwemeModel *)orig isAds]) return nil;
    if (!orig) return orig;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"px_duration_filter_enabled"]) {
        double dur = [[(AWEAwemeModel *)orig video].duration doubleValue] / 1000.0;
        double minD = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_min"] ?: 15;
        double maxD = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_max"] ?: 3600;
        if (dur > 0 && (dur < minD || dur > maxD)) return nil;
    }
    return orig;
}
"""
        lines = lines[:id_start] + new_id.split('\n') + ['\n'] + lines[id_end+1:]
    
    # Find init in first hook (after initWithDictionary replacement)
    # Re-scan
    hooks4 = []
    depth = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('%hook '):
            cls = stripped.split()[1]
            hooks4.append({'start': i, 'class': cls})
            depth += 1
        elif stripped == '%end':
            depth -= 1
            for h in reversed(hooks4):
                if 'end' not in h:
                    h['end'] = i
                    break
    
    awe_hooks4 = [h for h in hooks4 if h['class'] == 'AWEAwemeModel']
    first_awe4 = awe_hooks4[0]
    
    init_start = None
    init_end = None
    for j in range(first_awe4['start'] + 1, first_awe4['end'] + 1):
        if lines[j].strip() == '- (id)init {':
            init_start = j
        elif init_start and init_end is None and lines[j].strip() == '}':
            init_end = j
    
    if init_start and init_end:
        print(f"First AWEAwemeModel init: lines {init_start+1}-{init_end+1}")
        new_init = """- (id)init {
    id orig = %orig;
    if ([BHIManager hideAds] && [(AWEAwemeModel *)orig isAds]) return nil;
    if (!orig) return orig;
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
}
"""
        lines = lines[:init_start] + new_init.split('\n') + ['\n'] + lines[init_end+1:]

    # Add isUserRecommendBigCard to first AWEAwemeModel hook
    # Find %end of first AWEAwemeModel
    hooks5 = []
    depth = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('%hook '):
            cls = stripped.split()[1]
            hooks5.append({'start': i, 'class': cls})
            depth += 1
        elif stripped == '%end':
            depth -= 1
            for h in reversed(hooks5):
                if 'end' not in h:
                    h['end'] = i
                    break
    
    awe_hooks5 = [h for h in hooks5 if h['class'] == 'AWEAwemeModel']
    first_awe5 = awe_hooks5[0]
    
    # Insert isUserRecommendBigCard before %end
    insert_pos = first_awe5['end']
    new_method = """- (BOOL)isUserRecommendBigCard {
    return NO; // PXTok: always hide recommend cards
}
"""
    lines = lines[:insert_pos] + new_method.split('\n') + ['\n'] + lines[insert_pos:]

# Now remove all extra AWEAwemeModel hooks (2nd, 3rd, etc.)
# Re-scan
hooks6 = []
depth = 0
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('%hook '):
        cls = stripped.split()[1]
        hooks6.append({'start': i, 'class': cls})
        depth += 1
    elif stripped == '%end':
        depth -= 1
        for h in reversed(hooks6):
            if 'end' not in h:
                h['end'] = i
                break

awe_hooks6 = [h for h in hooks6 if h['class'] == 'AWEAwemeModel']
print(f"AWEAwemeModel hooks to remove: {len(awe_hooks6) - 1}")

# Remove extras in reverse order (to avoid index shifts)
for h in reversed(awe_hooks6[1:]):
    # Find comment block above
    comment_start = h['start']
    for i in range(h['start'] - 1, max(0, h['start'] - 15), -1):
        if '═══' in lines[i]:
            comment_start = i
            break
        elif lines[i].strip() == '':
            continue
        elif lines[i].strip().startswith('//') and '═══' not in lines[i]:
            continue
        else:
            comment_start = i + 1
            break
    
    print(f"Removing AWEAwemeModel hook (lines {comment_start+1}-{h['end']+1})")
    lines = lines[:comment_start] + lines[h['end']+1:]

with open(filepath, 'w', encoding='utf-8') as f:
    f.writelines(lines)

print("\nPhase 2 done: merged BDImageView + AWEAwemeModel hooks")
