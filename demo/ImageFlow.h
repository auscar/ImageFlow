//
//  ImageFlow.h
//  demo
//
//  Created by  on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFlow : NSObject<UIScrollViewDelegate>{
    UIView* view;
    
    UIScrollView* scrollview;
    UIView* trip1;
    UIView* trip2;
    int offset1;
    int offset2;
    
    NSMutableArray* images;//images数组刚开始的时候是字符串，当网络下载完成之后就是具体的UIImage实例了.
    NSMutableArray* imagePos;//每一个张图片在页面上的位置
    NSMutableArray* imageHeights;//每一个张图片在页面上的位置

    
    NSMutableDictionary* imageViewsCache;
    NSMutableDictionary* cellIsInViewTreeMap;

    
    //NSArray* imagePos1;//每一个张图片在页面上的位置
    //NSArray* imagePos2;//每一个张图片在页面上的位置
}

@property (nonatomic, retain) NSArray* images;
@property (nonatomic, retain) UIView* view;

-(void) calculatePosition;
-(void) logImagePos;
-(void) check:(CGPoint)loc;
-(UIImageView*) imageViewForFlowIndex:(int)index withImage:(id)image;
-(void) pinImage:(UIImage*)image withIndex:(int)index;
-(void) removeCellForIndex:(int)index;
-(void) setCellForIndex:(int)index;
-(void) toFit;

@end
