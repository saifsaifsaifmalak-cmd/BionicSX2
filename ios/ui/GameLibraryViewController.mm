#import "GameLibraryViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface GameLibraryViewController ()
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation GameLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.title = @"BionicSX2 — Select Game";
    self.isoFiles = [NSMutableArray array];

    UIBarButtonItem* importISO = [[UIBarButtonItem alloc]
        initWithTitle:@"＋ ISO"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(importISO)];

    UIBarButtonItem* importBIOS = [[UIBarButtonItem alloc]
        initWithTitle:@"BIOS"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(importBIOS)];

    self.navigationItem.rightBarButtonItems = @[importISO, importBIOS];

    self.tableView = [[UITableView alloc]
        initWithFrame:self.view.bounds
                style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.tableView];

    [self scanForGames];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scanForGames];
}

- (void)scanForGames {
    NSString* docs = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSArray* contents = [[NSFileManager defaultManager]
        contentsOfDirectoryAtPath:docs error:nil];
    [self.isoFiles removeAllObjects];
    NSArray* exts = @[@"iso", @"bin", @"img"];
    for (NSString* f in contents) {
        if ([exts containsObject:f.pathExtension.lowercaseString]) {
            [self.isoFiles addObject:[docs stringByAppendingPathComponent:f]];
        }
    }
    [self.tableView reloadData];
}

- (void)importISO {
    UIDocumentPickerViewController* picker;
    if (@available(iOS 14.0, *)) {
        picker = [[UIDocumentPickerViewController alloc]
            initForOpeningContentTypes:@[
                [UTType typeWithIdentifier:@"public.data"],
                [UTType typeWithIdentifier:@"public.iso-image"]
            ]];
    } else {
        picker = [[UIDocumentPickerViewController alloc]
            initWithDocumentTypes:@[@"public.data"]
                           inMode:UIDocumentPickerModeImport];
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)importBIOS {
    UIDocumentPickerViewController* picker;
    if (@available(iOS 14.0, *)) {
        picker = [[UIDocumentPickerViewController alloc]
            initForOpeningContentTypes:@[[UTType typeWithIdentifier:@"public.data"]]];
    } else {
        picker = [[UIDocumentPickerViewController alloc]
            initWithDocumentTypes:@[@"public.data"]
                           inMode:UIDocumentPickerModeImport];
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController*)ctrl
    didPickDocumentsAtURLs:(NSArray<NSURL*>*)urls {
    NSURL* url = urls.firstObject;
    if (!url) return;
    [url startAccessingSecurityScopedResource];

    NSString* docs = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* ext = url.pathExtension.lowercaseString;
    NSString* name = url.lastPathComponent.lowercaseString;

    BOOL isBIOS = [ext isEqualToString:@"bin"] && [name hasPrefix:@"scph"];
    NSString* destDir = isBIOS
        ? [docs stringByAppendingPathComponent:@"bios"]
        : docs;

    [[NSFileManager defaultManager]
        createDirectoryAtPath:destDir
        withIntermediateDirectories:YES
                   attributes:nil error:nil];

    NSString* dest = [destDir stringByAppendingPathComponent:url.lastPathComponent];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dest]) {
        NSError* err;
        [[NSFileManager defaultManager]
            copyItemAtPath:url.path toPath:dest error:&err];
        if (err) NSLog(@"[BionicSX2] Copy error: %@", err);
    }

    [url stopAccessingSecurityScopedResource];

    if (isBIOS) {
        [self.delegate gameLibraryDidSelectBIOS:dest];
    } else {
        [self.delegate gameLibraryDidSelectISO:dest];
    }
    [self scanForGames];
}

- (NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)s {
    return self.isoFiles.count ?: 1;
}

- (UITableViewCell*)tableView:(UITableView*)tv
        cellForRowAtIndexPath:(NSIndexPath*)ip {
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:@"game"];
    if (!cell) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"game"];
        cell.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        cell.textLabel.textColor = UIColor.whiteColor;
        cell.detailTextLabel.textColor = UIColor.grayColor;
    }
    if (self.isoFiles.count == 0) {
        cell.textLabel.text = @"No games — tap ＋ ISO to import";
        cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSString* path = self.isoFiles[ip.row];
        NSDictionary* attr = [[NSFileManager defaultManager]
            attributesOfItemAtPath:path error:nil];
        double mb = [attr fileSize] / 1024.0 / 1024.0;
        cell.textLabel.text = path.lastPathComponent;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f MB", mb];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (ip.row < self.isoFiles.count) {
        [self.delegate gameLibraryDidSelectISO:self.isoFiles[ip.row]];
    }
}

@end