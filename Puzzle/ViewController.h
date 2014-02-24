//
//  ViewController.h
//  Puzzle
//
//  Created by Syuuhi on 13-5-2.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleBoardView.h"

@interface ViewController : UIViewController<PuzzleBoardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImage *gambar;
    NSInteger step;
}
@property(nonatomic,retain)IBOutlet PuzzleBoardView *board;
@property(nonatomic,assign)IBOutlet UIButton *startButton;
@property(nonatomic,assign)IBOutlet UIButton *selectButton;
@property(nonatomic,assign)IBOutlet UISegmentedControl *boardSize;
@property (nonatomic, strong) UIPopoverController *popOver;
@property(nonatomic,assign) id delegate;
-(IBAction)start:(id)sender;
-(IBAction)selectImage:(id)sender;

@end
