//
//  PuzzleBoard.m
//  Puzzle
//
//  Created by Syuuhi on 13-5-2.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "PuzzleBoard.h"


@interface PuzzleBoard (Private)
-(NSMutableArray *)makeBoardWithSize:(NSInteger)size;
-(void)setTileAtPoint:(CGPoint)point withValue:(NSNumber *)value;
-(BOOL)isTileExist:(CGPoint)point;
-(BOOL)isTileEmpty:(CGPoint)point;

@end

@implementation PuzzleBoard

-(id)initWithSize:(NSInteger)size{
    self = [super init];
    if (self != nil) {
        _size = size;
        self.tiles = [self makeBoardWithSize:_size];
    }
    return self;
}

-(NSMutableArray *)makeBoardWithSize:(NSInteger)size{
    int value = 1;
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:size];
    for (int i = 0; i < size; i++) {
        NSMutableArray *colums = [NSMutableArray arrayWithCapacity:size];
        for (int j = 0; j < size; j++) {
            if (value == size * size) {
                [colums addObject:[NSNumber numberWithInt:0]];
            } else {
                [colums addObject:[NSNumber numberWithInt:value++]];
            }
        }
        [rows addObject:colums];
    }
    return rows;
}

-(void)setTileAtPoint:(CGPoint)point withValue:(NSNumber *)value{
    [[ _tiles objectAtIndex:point.y-1] replaceObjectAtIndex:point.x-1 withObject:value];
}

-(NSNumber *)getTileAtPoint:(CGPoint )point{
    return (NSNumber *)[[_tiles objectAtIndex:point.y-1] objectAtIndex:point.x-1];
}

-(BOOL)isTileExist:(CGPoint )point{
    if (point.x > 0 && point.y > 0 && point.x <= _size && point.y <= _size) {
        return YES;
    }
    return NO;
}

-(BOOL)isTileEmpty:(CGPoint )point{
    if ([[self getTileAtPoint:point] intValue] == 0) {
        return YES;
    }
    return NO;
}

-(void)swapTileAtPoint:(CGPoint)point1 withPoint:(CGPoint)point2{
    int temp = [(NSNumber *)[self getTileAtPoint:point1] intValue];
    [self setTileAtPoint:point1 withValue:[self getTileAtPoint:point2]];
    [self setTileAtPoint:point2 withValue:[NSNumber numberWithInt:temp]];
    
}

-(int)validMove:(CGPoint)tilePoint{
    CGPoint above = CGPointMake(tilePoint.x, tilePoint.y - 1);
    CGPoint below = CGPointMake(tilePoint.x, tilePoint.y + 1);
    CGPoint left = CGPointMake(tilePoint.x - 1, tilePoint.y);
    CGPoint right = CGPointMake(tilePoint.x + 1, tilePoint.y);
    
    if ([self isTileExist:above] && [self isTileEmpty:above]) {
        return UP;
    }
    if ([self isTileExist:below] && [self isTileEmpty:below]) {
        return DOWN;
    }

    if ([self isTileExist:left] && [self isTileEmpty:left]) {
        return LEFT;
    }
    
    if ([self isTileExist:right] && [self isTileEmpty:right]) {
        return RIGHT;
    }
    return NONE;
}

-(BOOL)isBoardFinished{
    int value = 1;
    
    for (int i = 1; i <= _size; i++) {
        for (int j = 1; j <= _size; j++) {
            NSLog(@"%d",[[self getTileAtPoint:CGPointMake(j, i)]intValue]);
            if (i==_size && j== _size) {
                break;
            }
            if ([[self getTileAtPoint:CGPointMake(j, i)] intValue] == value) {
                value++;
            }else{
                return NO;
            }
        }
    }

    return YES;
}

-(void)shuffle:(NSInteger)times{
    NSMutableArray *validArray = [[NSMutableArray alloc]init];
    srand(time(NULL));
    for (int n = 0; n<times; n++) {
        [validArray removeAllObjects];
        for (int i = 1 ; i<=_size; i++) {
            for (int j = 1; j<=_size; j++) {
                if ([self validMove:CGPointMake(j, i)] != NONE) {
                    [validArray addObject:[NSValue valueWithCGPoint:CGPointMake(j, i)]];
                }
            }
        }
        NSInteger pick = random()%[validArray count];
        CGPoint moveTile = [[validArray objectAtIndex:pick] CGPointValue];
        [self moveTile:moveTile];
    }
    [validArray release];
    
}

-(BOOL)moveTile:(CGPoint)tilePoint{
    CGPoint nbTilePoint;
    switch ([self validMove:tilePoint]) {
        case UP:
            nbTilePoint = CGPointMake(tilePoint.x, tilePoint.y - 1);
            [self swapTileAtPoint:tilePoint withPoint:nbTilePoint];
            break;
        case DOWN:
            nbTilePoint = CGPointMake(tilePoint.x, tilePoint.y + 1);
            [self swapTileAtPoint:tilePoint withPoint:nbTilePoint];
            break;
        case LEFT:
            nbTilePoint = CGPointMake(tilePoint.x - 1, tilePoint.y);
            [self swapTileAtPoint:tilePoint withPoint:nbTilePoint];
            break;
        case RIGHT:
            nbTilePoint = CGPointMake(tilePoint.x + 1, tilePoint.y);
            [self swapTileAtPoint:tilePoint withPoint:nbTilePoint];
            break;
            
        default:
            return NO;
            break;
    }
    return YES;
}

- (void)dealloc {
    self.tiles = nil;
    [super dealloc];
}


@end
