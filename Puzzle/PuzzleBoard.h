//
//  PuzzleBoard.h
//  Puzzle
//
//  Created by Syuuhi on 13-5-2.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NONE 0
#define UP 1
#define DOWN 2
#define LEFT 3
#define RIGHT 4

@interface PuzzleBoard : NSObject{
    
//   NSInteger _size;
 //   NSMutableArray *_tiles;
    
}

@property (atomic,assign) NSInteger size;
@property (atomic,retain) NSMutableArray *tiles;
-(id)initWithSize:(NSInteger )size;
-(NSNumber *)getTileAtPoint:(CGPoint )point;
-(void)swapTileAtPoint:(CGPoint )point1 withPoint:(CGPoint )point2;
-(int)validMove:(CGPoint )tilePoint;
-(BOOL)isBoardFinished;
-(void)shuffle:(NSInteger)times;
-(BOOL)moveTile:(CGPoint)tilePoint;

@end
