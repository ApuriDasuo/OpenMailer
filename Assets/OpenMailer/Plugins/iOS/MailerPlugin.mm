#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SocialWorker : NSObject<UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>
@property(nonatomic, retain) UIDocumentInteractionController *_dic;
@end

@implementation SocialWorker
/**
 * メール投稿
 * @param to 宛先。カンマ区切りの配列。
 * @param subject タイトル
 * @param message メッセージ
 */
- (void)postMail:(NSString *)to subject:(NSString *)subject message:(NSString *)message {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = self;
        [vc setToRecipients:[to componentsSeparatedByString:@","]];
        [vc setSubject:subject];
        [vc setMessageBody:message isHTML:NO];
        [UnityGetGLViewController() presentViewController:vc animated:YES completion:nil];
    } else {
    }
}

/** 
 * メール結果
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [UnityGetGLViewController() dismissViewControllerAnimated:YES completion:nil];
}

@end

/**
 * Unityから呼び出されるネイティブコード
 */
extern "C" {
    static SocialWorker *worker =[[SocialWorker alloc] init];
    UIViewController *UnityGetGLViewController();
    void UnitySendMessage(const char *, const char *, const char *);
    static NSString *getStr(char *str){
        if (str) {
            return [NSString stringWithCString: str encoding:NSUTF8StringEncoding];
        } else {
            return [NSString stringWithUTF8String: ""];
        }
    }
    void postMail(char *to, char *subject, char *message){
        [worker postMail:getStr(to) subject:getStr(subject) message:getStr(message)];
    }
}