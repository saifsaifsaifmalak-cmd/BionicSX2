#import <UIKit/UIKit.h>
#include "BionicLogger.hpp"
#include <string>

@interface LogViewerController : UIViewController
@end

@implementation LogViewerController {
    UITextView* _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Diagnostic Log";
    self.view.backgroundColor = [UIColor blackColor];

    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.editable = NO;
    _textView.backgroundColor = [UIColor blackColor];
    _textView.textColor = [UIColor greenColor];
    _textView.font = [UIFont fontWithName:@"Menlo" size:11];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];

    // زر Refresh
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self action:@selector(loadLog)];

    [self loadLog];
}

- (void)loadLog {
    BionicLog_Flush();
    std::string path = BionicLog_GetPath();
    NSString* nspath = [NSString stringWithUTF8String:path.c_str()];
    NSString* content = [NSString stringWithContentsOfFile:nspath
                        encoding:NSUTF8StringEncoding error:nil];
    if (!content) content = @"[Log file not found or empty]";
    _textView.text = content;

    // scroll للأسفل
    NSRange bottom = NSMakeRange(content.length - 1, 1);
    [_textView scrollRangeToVisible:bottom];
}
@end