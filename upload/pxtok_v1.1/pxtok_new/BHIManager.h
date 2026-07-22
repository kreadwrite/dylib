#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHIManager: NSObject

// ─── Лента ───
+ (BOOL)hideAds;
+ (BOOL)downloadButton;
+ (BOOL)shareSheet;
+ (BOOL)removeWatermark;
+ (BOOL)hideElementButton;
+ (BOOL)uploadRegion;
+ (BOOL)autoPlay;
+ (BOOL)stopPlay;
+ (BOOL)progressBar;
+ (BOOL)transparentCommnet;
+ (BOOL)showUsername;
+ (BOOL)disableUnsensitive;
+ (BOOL)disableWarnings;
+ (BOOL)disableLive;
+ (BOOL)skipRecommendations;

// ─── Профиль ───
+ (BOOL)profileSave;
+ (BOOL)profileCopy;
+ (BOOL)videoLikeCount;
+ (BOOL)videoUploadDate;

// ─── Подтверждения ───
+ (BOOL)likeConfirmation;
+ (BOOL)likeCommentConfirmation;
+ (BOOL)dislikeCommentConfirmation;
+ (BOOL)followConfirmation;

// ─── Другое ───
+ (BOOL)alwaysOpenSafari;
+ (BOOL)fakeChangesEnabled;
+ (BOOL)fakeVerified;
+ (BOOL)extendedBio;
+ (BOOL)extendedComment;
+ (BOOL)uploadHD;
+ (BOOL)appLock;

// ─── Регион ───
+ (BOOL)regionChangingEnabled;
+ (NSDictionary *)selectedRegion;

// ─── Скорость ───
+ (BOOL)speedEnabled;
+ (NSNumber *)selectedSpeed;

// ─── Live-кнопка ───
+ (BOOL)liveActionEnabled;
+ (NSNumber *)selectedLiveAction;

// ─── PXTok Extra ───
+ (BOOL)autoDownloadFavorites;
+ (BOOL)translateDescription;
+ (BOOL)translateComment;
+ (BOOL)copyCommentWithoutUsername;
+ (BOOL)hidePlusButton;
+ (BOOL)hideNotificationBadges;
+ (BOOL)disableCommentTooltips;
+ (BOOL)oledKeyboard;
+ (BOOL)hideEmojiPanel;
+ (BOOL)autoExpandReplies;
+ (BOOL)hapticsAdjustEnabled;
+ (BOOL)hideLiveBadge;
+ (BOOL)transparentNavBar;

// ─── Режим призрака ───
+ (BOOL)ghostPrivacyScreen;
+ (BOOL)ghostClipboardClear;
+ (BOOL)ghostHideFromSpotlight;
+ (BOOL)ghostNoStoryMark;
+ (BOOL)ghostNoVideoMark;
+ (BOOL)disableReadReceipt;
+ (BOOL)ghostHideOnline;
+ (BOOL)ghostHideTyping;
+ (BOOL)ghostStealthProfile;

// ─── Удалённые сообщения ───
+ (BOOL)deletedMessagesEnabled;
+ (float)deletedMessageOpacity;
+ (BOOL)deletedMessageSameStyle;

// ─── Автопродление огонька ───
+ (BOOL)streakAutoRenewEnabled;
+ (NSString *)streakScheduledTime;
+ (NSString *)streakMessageText;

// ─── Утилиты ───
+ (BOOL)isEmpty:(NSURL *)url;
+ (NSString *)getDownloadingPersent:(float)per;
+ (void)showSaveVC:(id)item;
+ (void)cleanCache;
+ (void)saveMedia:(id)item fileExtension:(id)fileExtension;
+ (BOOL)isRussian;

@end
