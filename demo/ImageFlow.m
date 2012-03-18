//
//  ImageFlow.m
//  demo
//
//  Created by  on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageFlow.h"

@implementation ImageFlow
@synthesize images;
@synthesize view;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        scrollview = [[UIScrollView alloc] init];
        scrollview.delegate = self;
        scrollview.scrollEnabled = YES;
        
        scrollview.frame = CGRectMake(0, 44, 320, 460);
        
        trip1 = [[UIView alloc] initWithFrame:CGRectMake(6, 0, 151, scrollview.frame.size.height)];
        trip2 = [[UIView alloc] initWithFrame:CGRectMake(163, 0, 151, scrollview.frame.size.height)];
    
        [scrollview addSubview:trip1];
        [scrollview addSubview:trip2];
        
        view = scrollview;
    }
    
    return self;
}


#pragma mark 
-(CGFloat) getHeight:(UIImage *)image withWidth:(CGFloat)width{
    if(!image)return 0.0f;
    
    CGFloat rate = image.size.height/image.size.width;
    
    return floor(width*rate);
    
}
-(void) toFit{
    [trip1 sizeToFit];
    [trip2 sizeToFit];
    [view sizeToFit];
}
-(void) loadData{
    [self calculatePosition];
    [self logImagePos];
    [self check];
}
-(void) clearFlow{
    NSArray* svs1 = [trip1 subviews];
    if ([svs1 count]) {
        for (int j=0; j<[svs1 count]; j++) {
            [[svs1 objectAtIndex:j] removeFromSuperview];
        }
    }
    NSArray* svs2 = [trip2 subviews];
    if ([svs2 count]) {
        for (int j=0; j<[svs2 count]; j++) {
            [[svs2 objectAtIndex:j] removeFromSuperview];
        }
    }
}
-(void) calculatePosition{
    //移除所有的view
    [self clearFlow];
    
    CGFloat imageHeight;
    imagePos = [[NSMutableArray alloc] initWithArray:images];
    imageHeights = [[NSMutableArray alloc] initWithArray:images];
    imageViewsCache = [[NSMutableDictionary alloc] init];
    cellIsInViewTreeMap = [[NSMutableDictionary alloc] init];
    
    
    offset1 = 0;
    offset2 = 0;
    
    //NSLog(@"images 内有%d张图片", [images count]);
    NSLog(@"开始遍历图片，计算各个图片的位置------------------------");
    //遍历数组内的图片, 计算他们的位置
    for (int i=0; i<[images count]; i++) {
        
        //------------------ 计算图片高度 --------------------------
        imageHeight = 180;//图片默认高度是180
        //图片加载了就用图片的高度; 图片还没有加载, 就用默认的长度
        if([[images objectAtIndex:i] isKindOfClass:[UIImage class]]){
            imageHeight = [self getHeight:(UIImage*)[images objectAtIndex:i] withWidth:151];
        }
        //记录这张图片的高度
        [imageHeights replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:imageHeight]];
        
        // ----------------- 计算图片应该在的位置 --------------------
        if(i%2==0){//第一列
            NSLog(@"(%@)图片%d在第0列, offset是%d, 高度是 %f",[[[images objectAtIndex:i] class] description],i, offset1, imageHeight);
            //[imagePos addObject:[NSNumber numberWithInt:offset1 ]];
            [imagePos replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:offset1 ]];
            offset1 += (imageHeight + 7);
        }else{//第二列
            NSLog(@"(%@)图片%d在第1列, offset是%d, 高度是 %f",[[[images objectAtIndex:i] class] description],i, offset2, imageHeight);
            //[imagePos addObject:[NSNumber numberWithInt:offset2 ]];
            [imagePos replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:offset2 ]];
            offset2 += (imageHeight + 7);
        }
    }
    
    //calculate之后, 拿它最后两个元素计算contentSize
    int lastPos = [[imagePos objectAtIndex:([images count]-1)] intValue];
    lastPos = lastPos + [[imageHeights objectAtIndex:([images count]-1)] intValue] + 6;
    
    if ([images count] > 1) {
        int lastPos2 = [[imagePos objectAtIndex:([images count]-2)] intValue];
        lastPos2 = lastPos2 + [[imageHeights objectAtIndex:([images count]-2)] intValue] + 6;
        if (lastPos2>lastPos) {
            lastPos = lastPos2;
        }
    }
    
    scrollview.contentSize = CGSizeMake(320, lastPos);
    
}
-(void) logImagePos{
    //NSLog(@"imagePos length %d", [imagePos count]);
    for (int i=0; i<[images count]; i++) {
        //int pos = [(NSNumber*)[imagePos objectAtIndex:i] intValue];
        //NSLog(@"图片%d的位置是%d", i, pos);
    }
}
-(void) removeCellForIndex:(int)index{
    NSNumber* num = [NSNumber numberWithInt:index];
    BOOL isIn = [[cellIsInViewTreeMap objectForKey:num] boolValue];

    //在view tree上的view才remove
    if (isIn) {
        //NSLog(@"view %d 移出", index);
        [[imageViewsCache objectForKey:[NSNumber numberWithInt:index]] removeFromSuperview];
        [cellIsInViewTreeMap setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:index]];
    }
}

-(void) setCellForIndex:(int)index{
    NSNumber* num = [NSNumber numberWithInt:index];
    BOOL isIn = [[cellIsInViewTreeMap objectForKey:num] boolValue];
    
    // 不在view tree上就插入一个~   
    if (!isIn) {
        //NSLog(@"view %d 移入", index);
        [self pinImage:[images objectAtIndex:index] withIndex:index];
    }
}

-(void) check{
    CGPoint loc = [scrollview contentOffset];
    int tmp;
    int imgHeight;
    UIImageView* iv;
    NSNumber* num;
    
    NSLog(@"遍历所有的图片================================== 在可视区域的图片显示出来, 不在的就移除=====");
    for (int i=0; i<[images count]; i++) {
        imgHeight = 180;//默认图片180
        tmp = [[imagePos objectAtIndex:i] intValue];
        iv = [imageViewsCache objectForKey:[NSNumber numberWithInt:i]];
        if(iv){
            imgHeight = [self getHeight:iv.image withWidth:151];
        }
        
        num = [NSNumber numberWithInt:i];
        BOOL isIn = [[cellIsInViewTreeMap objectForKey:num] boolValue];
        
        
        //可视区域内的图片需要显示
        if ( (tmp>=loc.y&&(tmp<=loc.y+460))||(((tmp+imgHeight)>=loc.y)&&(tmp+imgHeight<=loc.y+460)) ) {
            if (!isIn) {
                //NSLog(@"tmp%d*****%f******%d",i,loc.y,tmp);
            }
            [self setCellForIndex:i];
        }else{
            [self removeCellForIndex:i];
        }
    }
}

-(UIImageView*) imageViewForFlowIndex:(int)index withImage:(UIImage *)image{
    UIImageView* imgView = [imageViewsCache objectForKey:[NSNumber numberWithInt:index]];
    if(imgView){
        //NSLog(@"已经有imageView直接返回");
        return imgView;
    }
    
    imgView = [[[UIImageView alloc] init] autorelease];//TODO
    imgView.backgroundColor = [UIColor grayColor];
    if ([image isKindOfClass:[UIImage class]]) {
        imgView.image = image;
    }else{
        //NSLog(@"需要展示的图片没有加载");
    }
    return imgView;
}
-(void) pinImage:(UIImage *)image withIndex:(int)index{
    //NSLog(@"pin image!!!!");
    
    int x = 0;
    int y;
    int width = 151;
    int height = 180;
    
    UIImageView* imageView = [self imageViewForFlowIndex:index withImage:image];
    
    y = [[imagePos objectAtIndex:index] intValue];
    
    
    [imageViewsCache setObject:imageView forKey:[NSNumber numberWithInt:index]];
    
    //有图片的话高度可是要算的了
    if([imageView image]!= nil){
        height = [self getHeight:imageView.image withWidth:151];
    }
    
    imageView.frame = CGRectMake(x, y, width, height);
    imageView.backgroundColor = [UIColor grayColor];
    if(index%2==0){
        [trip1 addSubview:imageView];
    }else{
        [trip2 addSubview:imageView];
    }
    [cellIsInViewTreeMap setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:index]];
}
-(void) dealloc{
    [view release];
    
    [scrollview release];
    [trip1 release];
    [trip2 release];
    
    [images release];
    [imagePos release];
    [imageViewsCache release];
    [cellIsInViewTreeMap release];
}
#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self check];
}




@end


















