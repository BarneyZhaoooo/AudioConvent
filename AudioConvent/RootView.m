//
//  RootView.m
//  AudioConvent
//
//  Created by DuJin on 2017/4/6.
//  Copyright © 2017年 Du Jin. All rights reserved.
//

#import "RootView.h"

@interface RootView ()

@property (nonatomic, strong) NSMutableArray    *filePathArr;
@property (nonatomic) BOOL                      isDragIn;

@property (nonatomic, strong) NSTextView        *filePathsTV;

@end



@implementation RootView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSLog(@"rootview.frame:%f,%f",self.frame.size.width,self.frame.size.height);
        
        // 拖拽实现
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        
        // 拖拽识别路径
        [self addSubview:self.filePathsTV];
        
        // 转换按钮
        NSButton *startBtn = [NSButton buttonWithTitle:@"开始"
                                                target:self
                                                action:@selector(clickedStartBtn)];
        startBtn.frame = NSMakeRect(10.0f,
                                    10.0f,
                                    100.0f,
                                    50.0f);
        [self addSubview:startBtn];
        
        // 进度
//        NSTextField *progressTF = [[NSTextField alloc] initWithFrame:NSMakeRect(10.0f + 100.0f + 20.0f,
//                                                                                10.0f,
//                                                                                50.0f,
//                                                                                40.0f)];
//        progressTF.editable = NO;
//        progressTF.bezeled = NO;
//        progressTF.drawsBackground = NO;
//        progressTF.selectable = NO;
//        progressTF.font = [NSFont systemFontOfSize:14.0f];
//        progressTF.textColor = [NSColor redColor];
//        progressTF.stringValue = @"0.0%";
//        [self addSubview:progressTF];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (self.isDragIn)
    {
        NSColor* color = [NSColor colorWithRed:200.0f / 255.0f
                                         green:200.0f / 255.0f
                                          blue:200.0f / 255.0f
                                         alpha:1.0f];
        [color set];
        NSBezierPath* thePath = [NSBezierPath bezierPath];
        [thePath appendBezierPathWithRoundedRect:dirtyRect
                                         xRadius:8.0f
                                         yRadius:8.0f];
        [thePath fill];
    }
}

#pragma mark - Private Methods
- (NSString *)runCommand:(NSString *)commandToRun {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", [NSString stringWithFormat:@"%@", commandToRun], nil];
    NSLog(@"run command: %@",commandToRun);
    [task setArguments: arguments];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    NSData *data = [file readDataToEndOfFile];
    NSString *output;
    output = [[NSString alloc] initWithData:data
                                   encoding:NSUTF8StringEncoding];
    return output;
}

#pragma mark - Destination Operations
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    self.isDragIn = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    self.isDragIn = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    self.isDragIn = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    if ([sender draggingSource] != self) {
        NSArray *filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        
        [self.filePathArr removeAllObjects];
        
        NSString *pathsStr = @"待转换文件:\n";
        
        for (NSString *path in filePaths) {
            if ([path componentsSeparatedByString:@"."].count > 1) {
                [self.filePathArr addObject:path];
                pathsStr = [pathsStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",path]];
            }
        }
        
        self.filePathsTV.string = pathsStr;
    }
    
    return YES;
}

#pragma mark - Control Events
- (void)clickedStartBtn {
    NSString *ffprobePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"ffmpeg"];
    
    for (NSString *filePath in self.filePathArr) {
        NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
        NSString *finderPath = [filePath stringByReplacingOccurrencesOfString:fileName
                                                                   withString:@""];
        NSString *newFilePath = [NSString stringWithFormat:@"%@/%@.mp3",finderPath,[[fileName componentsSeparatedByString:@"."] firstObject]];
        
        NSString *commandStr = [NSString stringWithFormat:@"%@ -i %@ -b:a 320k -acodec mp3 -ar 44100 -ac 2 %@",ffprobePath, filePath, newFilePath];
        
        NSLog(@"%@",[self runCommand:commandStr]);
    }
}

#pragma mark - Getters & Setters
- (NSMutableArray *)filePathArr {
    if (_filePathArr == nil) {
        _filePathArr = [NSMutableArray array];
    }
    
    return _filePathArr;
}

- (NSTextView *)filePathsTV {
    if (_filePathsTV == nil) {
        _filePathsTV = [[NSTextView alloc] initWithFrame:NSMakeRect(10.0f,
                                                                    60.0f,
                                                                    self.frame.size.width - 20.0f,
                                                                    self.frame.size.height - 70.0f)];
        _filePathsTV.editable = NO;
        _filePathsTV.drawsBackground = NO;
        _filePathsTV.selectable = NO;
    }
    
    return _filePathsTV;
}

@end
