//
//  PuzzleBoardView.m
//  Puzzle
//
//  Created by Syuuhi on 13-6-1.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PuzzleBoardView.h"
#import "PuzzleBoard.h"
#import "UIImage+Resize.h"

@interface PuzzleBoardView (Private)
-(void)drawPuzzle;
-(void)tapMove:(UITapGestureRecognizer *)tapRecognizer;
-(void)movingThisTile:(CGPoint)tilePoint;
-(void)moveTile:(UIImageView *)tile withDirection:(int)direction;
@end

@implementation PuzzleBoardView


-(void)awakeFromNib
{
    [super awakeFromNib];
    _fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 600, 600)];
    //边框阴影
    _fullImageView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    _fullImageView.layer.shadowRadius = 1.5;
    _fullImageView.layer.shadowOpacity = 0.65;
    [_fullImageView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_fullImageView.layer setBorderWidth:1];

}

-(void)setImageForView:(UIImage *)image{
    
    for (id view in self.subviews)
    {
        [view removeFromSuperview];
    }
    [self addSubview:_fullImageView];
    [_fullImageView setImage:image];
        //[self playWithImage:resizedImage andSize:size];
}


-(void)playWithImage:(UIImage *)image andSize:(NSInteger)size{
    //[self initWithImage:resizedImage];
    _board = [[PuzzleBoard alloc]initWithSize:size];
    //[board release];
    //UIImage *resizedImage= [image resizedImageWithSize:CGSizeMake(600, 600)];
    _tileWidth = image.size.width/size;
    _tileHeight = image.size.height/size;
    _tiles = [[[NSMutableArray alloc]init]autorelease];
    for (int i = 0; i<size; i++) {
        for (int j = 0; j<size; j++) {
            CGRect frame = CGRectMake(_tileWidth*j, _tileHeight*i, _tileWidth, _tileHeight);
            UIImage *tileImage = [image cropImageFromFrame:frame];
            UIImageView *tileImageView = [[UIImageView alloc]initWithImage:tileImage];
            
            //边框阴影
            tileImageView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
            tileImageView.layer.shadowRadius = 1.5;
            tileImageView.layer.shadowOpacity = 0.65;
            [tileImageView.layer setBorderColor:[UIColor grayColor].CGColor];
            [tileImageView.layer setBorderWidth:1];
            //[tileImageView.layer setShadowPath:[UIBezierPath bezierPathWithRect:tileImageView.layer.frame].CGPath];
                        
            [_tiles addObject:tileImageView];
            [tileImageView release];
        }
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMove:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    [self play];
}

-(void)play{
    [_board shuffle:SHUFFLE_TIMES];
    NSLog(@"play");
    [self drawPuzzle];
}

-(void)drawPuzzle{
    for(id view in self.subviews){
        [view removeFromSuperview];
    }
    for (int i=1; i<=_board.size; i++) {
        for (int j =1; j<=_board.size; j++) {
            NSNumber *value = [_board getTileAtPoint:CGPointMake(j, i)];
            if ([value intValue]==0 ) {
                continue;
            }
            
            UIImageView *tileImageView = [_tiles objectAtIndex:[value intValue]-1];
            CGRect frame = CGRectMake(_tileWidth*(j-1), _tileHeight*(i-1), _tileWidth, _tileHeight);
            tileImageView.frame = frame;
            [self addSubview:tileImageView];
        }
    }
}

-(void)tapMove:(UITapGestureRecognizer *)tapRecognizer{
    CGPoint tapPoint = [tapRecognizer locationInView:self];
    int x = (tapPoint.x / _tileWidth) + 1;
    int y = (tapPoint.y / _tileHeight) + 1;
    NSLog(@"tap %d+%d",x,y);
    [self movingThisTile:CGPointMake(x, y)];
    
}

-(void)movingThisTile:(CGPoint)tilePoint{
    UIImageView *tileView = [[UIImageView alloc]init];
    CGRect checkRect = CGRectMake((tilePoint.x-1)*_tileWidth+1, (tilePoint.y-1)*_tileHeight+1, 1, 1);
    for (UIImageView *tile in self.subviews) {
        if (CGRectIntersectsRect(tile.frame, checkRect)) {
            tileView = tile;
            break;
        }
    }
    int move = [_board validMove:tilePoint];
    CGPoint nbPoint;
    switch (move) {
        case UP:
            nbPoint = CGPointMake(tilePoint.x, tilePoint.y-1);
            [_board swapTileAtPoint:tilePoint withPoint:nbPoint];
            [self moveTile:tileView withDirection:move];
            if (self.delegate) {
                [self.delegate puzzleBoard:self emptyTileDidMoveedTo:tilePoint];
            }
            break;

        case DOWN:
            nbPoint = CGPointMake(tilePoint.x, tilePoint.y+1);
            [_board swapTileAtPoint:tilePoint withPoint:nbPoint];
            [self moveTile:tileView withDirection:move];
            if (self.delegate) {
                [self.delegate puzzleBoard:self emptyTileDidMoveedTo:tilePoint];
            }
            break;
        case LEFT:
            nbPoint = CGPointMake(tilePoint.x-1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:nbPoint];
            [self moveTile:tileView withDirection:move];
            if (self.delegate) {
                [self.delegate puzzleBoard:self emptyTileDidMoveedTo:tilePoint];
            }
            break;

        case RIGHT:
            nbPoint = CGPointMake(tilePoint.x+1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:nbPoint];
            [self moveTile:tileView withDirection:move];
            if (self.delegate) {
                [self.delegate puzzleBoard:self emptyTileDidMoveedTo:tilePoint];
            }
            break;

        default:
            NSLog(@"不能移动");
            break;
    }
    //[tileView release];
}

-(void)moveTile:(UIImageView *)tile withDirection:(int)direction{
    CGRect newFrame;
    switch (direction) {
        case UP:
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y-_tileHeight, _tileWidth, _tileHeight);
            break;
        case DOWN:
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y+_tileHeight, _tileWidth, _tileHeight);
            break;
        case LEFT:
            newFrame = CGRectMake(tile.frame.origin.x-_tileWidth, tile.frame.origin.y, _tileWidth, _tileHeight);
            break;
        case RIGHT:
            newFrame = CGRectMake(tile.frame.origin.x+_tileWidth, tile.frame.origin.y, _tileWidth, _tileHeight);
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{tile.frame = newFrame;}
                     completion:^(BOOL finished){
                         if (finished) {
                             if ([_board isBoardFinished]) {
                                 //NSLog(@"完成");
                                 if (self.delegate) {
                                     [self.delegate puzzleBoardDidFinished:self];
                                 }
                                 
                             }
                         }
                     }
     ];
}
-(void)dealloc{
    [_fullImageView release];
    self.delegate = nil;
    self.tiles = nil;
    self.board = nil;
    [super dealloc];
}

@end
