//
//  ViewController.m
//  Puzzle
//
//  Created by Syuuhi on 13-5-2.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "ViewController.h"
#import "MCSteamView.h"
#import "UIImage+Resize.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    //CGRect frame  = [[UIScreen mainScreen]applicationFrame];
    //self.view.frame = frame;
    UIImage *fullImage = [UIImage imageNamed:@"bak.png"];
    UIImage *resizedImage = [fullImage resizedImageWithSize:CGSizeMake(600, 600)];
    
    gambar = [resizedImage retain];
    //_board = [[PuzzleBoardView alloc] initWithImage:gambar];
    [_board setImageForView:gambar];
    _board.delegate = self;
    //[fullImage release];
    [resizedImage release];
//    CGRect bouns = self.view.bounds;
//    CGRect frame = CGRectMake(300,300,200,100);
//    MCSteamView *steam = [[MCSteamView alloc]initWithFrame:frame];
//    steam.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:steam];
// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _board = nil;
    _boardSize = nil;
    _startButton = nil;
    [super dealloc];
}


-(IBAction)start:(id)sender{
    step = 0;
    [_board setUserInteractionEnabled:YES];
    [_startButton setTitle:@"重新开始" forState:UIControlStateNormal];
    [_board playWithImage:gambar andSize:_boardSize.selectedSegmentIndex + 3];
    NSLog(@"start with %d!",_boardSize.selectedSegmentIndex + 3);
    
}

-(IBAction)selectImage:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.editing = YES;
        picker.navigationBar.opaque = true;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:self.board.bounds inView:self.board permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popOver = popover;
        [popover release];
        //UIViewController *container = [[UIViewController alloc]init];
        
        //[self presentViewController:picker animated:YES completion:NULL];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"无法获取图片" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[picker presentedViewController]dismissViewControllerAnimated:YES completion:^(void){}];
    //NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [selectedImage resizedImageWithSize:_board.frame.size];
    //gambar = nil;
    gambar = [resizedImage retain];
    [_board setImageForView:gambar];
    //[selectedImage release];
    [resizedImage release];
    
}

-(void)puzzleBoardDidFinished:(PuzzleBoardView *)board{
    UIImageView *fullImage = [[UIImageView alloc]initWithImage:gambar];
    //边框阴影
    fullImage.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    fullImage.layer.shadowRadius = 1.5;
    fullImage.layer.shadowOpacity = 0.65;
    [fullImage.layer setBorderColor:[UIColor grayColor].CGColor];
    [fullImage.layer setBorderWidth:1];
    fullImage.alpha = 0.0;
    for (id view in self.board.subviews) {
        [view removeFromSuperview];
    }
    [_board addSubview:fullImage];
    [UIView animateWithDuration:0.5
                     animations:^{
                         fullImage.alpha = 1.0;
                     }completion:^(BOOL finished){
                         NSLog(@"你完成了 %d * %d 的拼图！",[_boardSize selectedSegmentIndex]+3,[_boardSize selectedSegmentIndex]+3);
                         [board setUserInteractionEnabled:NO];
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"完成" message:@"恭喜你，完成了该拼图！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                         [_startButton setTitle:@"开始游戏" forState:UIControlStateNormal];
                     }];
}

-(void)puzzleBoard:(PuzzleBoardView *)board emptyTileDidMoveedTo:(CGPoint)titlePoint{
    step += 1;
}

@end
