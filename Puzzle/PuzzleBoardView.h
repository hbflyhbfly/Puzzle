//
//  PuzzleBoardView.h
//  Puzzle
//
//  Created by Syuuhi on 13-6-1.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BOARD_SIZE 4
#define SHUFFLE_TIMES   20

@class PuzzleBoard;

@protocol PuzzleBoardDelegate;

@interface PuzzleBoardView : UIView{
    UIImageView *_fullImageView;
    int _direction;
    
}

@property (nonatomic,assign) id<PuzzleBoardDelegate> delegate;
@property CGFloat tileWidth;
@property CGFloat tileHeight;
@property (nonatomic,retain) PuzzleBoard *board;
@property (nonatomic,retain) NSMutableArray *tiles;

- (void)setImageForView:(UIImage *)image;

-(void)playWithImage:(UIImage *)image andSize:(NSInteger)size;

-(void)play;

@end

@protocol PuzzleBoardDelegate

-(void)puzzleBoard:(PuzzleBoardView *)board emptyTileDidMoveedTo:(CGPoint)titlePoint;
-(void)puzzleBoardDidFinished:(PuzzleBoardView *)board;


@end