//
//  ESPuzzleGamePiece.m
//  EnjoyGameGame
//
//  Created by JiongXing on 2016/11/11.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "ESPuzzleGamePiece.h"

@implementation ESPuzzleGamePiece

+ (instancetype)pieceWithID:(NSInteger)ID image:(UIImage *)image {
    ESPuzzleGamePiece *piece = [[ESPuzzleGamePiece alloc] init];
    piece.ID = ID;
    piece.layer.borderWidth = 0.8;
    piece.layer.borderColor = [UIColor blackColor].CGColor;
    [piece setBackgroundImage:image forState:UIControlStateNormal];
    return piece;
}

@end
