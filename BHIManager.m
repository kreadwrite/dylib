#import "BHIManager.h"
#import "TikTokHeaders.h"

@implementation BHIManager
+ (BOOL)hideAds {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_ads"];
}
+ (BOOL)downloadButton {
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"download_button"];
}
+ (BOOL)shareSheet {
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"share_sheet"];
}
+ (BOOL)removeWatermark {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_watermark"];
}
+ (BOOL)hideElementButton {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_elements_button"];
}
+ (BOOL)uploadRegion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"upload_region"];
}
+ (BOOL)autoPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_play"];
}
+ (BOOL)stopPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"stop_play"];
}
+ (BOOL)progressBar {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"show_porgress_bar"];
}
+ (BOOL)transparentCommnet {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"transparent_commnet"];
}
+ (BOOL)showUsername {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"show_username"];
}
// disablePullToRefresh defined below at line 101
+ (BOOL)disableUnsensitive {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_unsensitive"];
}
+ (BOOL)disableWarnings {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_warnings"];
}
+ (BOOL)disableLive {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_live"];
}
+ (BOOL)skipRecommendations {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"skip_recommnedations"];
}
+ (BOOL)likeConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_confirm"];
}
+ (BOOL)likeCommentConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"like_comment_confirm"];
}
+ (BOOL)dislikeCommentConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"dislike_comment_confirm"];
}
+ (BOOL)followConfirmation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"follow_confirm"];
}
+ (BOOL)profileSave {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"save_profile"];
}
+ (BOOL)profileCopy {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"copy_profile_information"];
}
// profileVideoCount defined below at line 98
+ (BOOL)alwaysOpenSafari {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"openInBrowser"];
}
+ (BOOL)regionChangingEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_region"];
}
+ (BOOL)speedEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"playback_en"];
}
+ (BOOL)liveActionEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_livefunc"];
}
+ (NSNumber *)selectedLiveAction {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"live_action"];
}
+ (NSNumber *)selectedSpeed {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"playback_speed"];
}
+ (BOOL)videoLikeCount {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"video_like_count"];
}
+ (BOOL)videoUploadDate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"video_upload_date"];
}
+ (BOOL)profileVideoCount {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"profile_video_count"];
}
+ (BOOL)disablePullToRefresh {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_pull_to_refresh"];
}
+ (NSDictionary *)selectedRegion {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"region"];
}
+ (BOOL)fakeChangesEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"en_fake"];
}
+ (BOOL)fakeVerified {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"fake_verify"];
}
+ (BOOL)extendedBio {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"extended_bio"];
}
+ (BOOL)extendedComment {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"extendedComment"];
}
+ (BOOL)uploadHD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"upload_hd"];
}
+ (BOOL)appLock {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"padlock"];
}
+ (BOOL)autoDownloadFavorites {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_dw_favorites"];
}
+ (BOOL)translateDescription {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"translate_description"];
}
+ (BOOL)translateComment {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"translate_comment"];
}
+ (BOOL)copyCommentWithoutUsername {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"copy_comment_no_username"];
}
+ (BOOL)hidePlusButton {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_plus_button"];
}
+ (BOOL)hideNotificationBadges {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_notification_badges"];
}
+ (BOOL)disableCommentTooltips {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_comment_tooltips"];
}
+ (BOOL)disableReadReceipt {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disable_read_receipt"];
}
+ (BOOL)oledKeyboard {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"oled_keyboard"];
}
+ (BOOL)hideEmojiPanel {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hide_emoji_panel"];
}
+ (BOOL)autoExpandReplies {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_expand_replies"];
}
+ (BOOL)hapticsAdjustEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_haptics_adjust_enabled"];
}
+ (BOOL)hideLiveBadge {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_hide_live_badge"];
}
+ (BOOL)transparentNavBar {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_transparent_navbar"];
}
+ (BOOL)ghostPrivacyScreen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_privacy_screen"];
}
+ (BOOL)ghostClipboardClear {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_clipboard_clear"];
}
+ (BOOL)ghostHideFromSpotlight {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_hide_spotlight"];
}
+ (void)cleanCache {
    NSArray <NSURL *> *DocumentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in DocumentFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"png"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"m4a"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
    }
    
    NSArray <NSURL *> *TempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSTemporaryDirectory()] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in TempFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mov"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"tmp"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"png"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"m4a"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file hasDirectoryPath]) {
            if ([BHIManager isEmpty:file]) {
                [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
            }
        }
    }
}
+ (BOOL)isEmpty:(NSURL *)url {
    NSArray *FolderFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    if (FolderFiles.count == 0) {
        return true;
    } else {
        return false;
    }
}
+ (void)showSaveVC:(id)item {
    UIActivityViewController *acVC = [[UIActivityViewController alloc] initWithActivityItems:item applicationActivities:nil];
    if (is_iPad()) {
        acVC.popoverPresentationController.sourceView = topMostController().view;
        acVC.popoverPresentationController.sourceRect = CGRectMake(topMostController().view.bounds.size.width / 2.0, topMostController().view.bounds.size.height / 2.0, 1.0, 1.0);
    }
    [topMostController() presentViewController:acVC animated:true completion:nil];
}
+ (void)saveMedia:(id)newFilePath fileExtension:(id)fileextension {
    NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"gif", @"tiff", @"bmp", @"heif", @"heic", @"svg"];
    NSArray *videoExtensions = @[@"mp4", @"mov", @"avi", @"mkv", @"wmv", @"flv", @"webm"];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        if ([videoExtensions containsObject:fileextension]) {
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypeVideo fileURL:newFilePath options:options];
        } else if ([imageExtensions containsObject:fileextension]) {
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto fileURL:newFilePath options:options];
        } else {
            NSLog(@"Unsupported file type: %@", fileextension);
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Media saved to Camera Roll successfully.");
        } else {
            NSLog(@"Error saving media to Camera Roll: %@", error);
        }
    }];
}

+ (NSString *)getDownloadingPersent:(float)per {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *number = [NSNumber numberWithFloat:per];
    return [numberFormatter stringFromNumber:number];
}
// ─── Режим призрака (новые) ───
+ (BOOL)ghostNoStoryMark {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_no_story_mark"];
}
+ (BOOL)ghostNoVideoMark {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_no_video_mark"];
}
+ (BOOL)ghostHideOnline {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_hide_online"];
}
+ (BOOL)ghostHideTyping {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_hide_typing"];
}
+ (BOOL)ghostStealthProfile {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_ghost_stealth_profile"];
}

// ─── Удалённые сообщения ───
+ (BOOL)deletedMessagesEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_deleted_messages_enabled"];
}
+ (float)deletedMessageOpacity {
    NSNumber *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"px_deleted_msg_opacity"];
    return v ? [v floatValue] : 0.4f;
}
+ (BOOL)deletedMessageSameStyle {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_deleted_msg_same_style"];
}

// ─── Автопродление огонька ───
+ (BOOL)streakAutoRenewEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"px_streak_auto_renew"];
}
+ (NSString *)streakScheduledTime {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"px_streak_time"] ?: @"20:00";
}
+ (NSString *)streakMessageText {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"px_streak_message"] ?: @"🔥";
}

// ─── Утилита ───
+ (BOOL)isRussian {
    return [[[NSUserDefaults standardUserDefaults] stringForKey:@"px_language"] isEqualToString:@"ru"];
}
@end
