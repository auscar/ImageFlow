//
//  demoViewController.m
//  demo
//
//  Created by  on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "demoViewController.h"
#import "ImageFlow.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASICacheDelegate.h"
#
#import "SBJson.h"

#define webRoot @"api.haoduojie.com"

@implementation demoViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) download:(NSString*)url withIndex:(int)index{
    
    NSLog(@"异步获取图片data");
    NSURL *uri = [[NSURL alloc] initWithString:url];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:uri];
    req.delegate = self;
    req.didFinishSelector = @selector(didFinishDownload:);
    req.username = [NSString stringWithFormat:@"%d",index];
    req.didFailSelector = @selector(didFailDownload:);
    [req setDownloadCache:[ASIDownloadCache sharedCache]];
    [req setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];//缓存策略是仅使用缓存的数据, 不再向服务器发请求
    [req startSynchronous];
}
-(void)didFinishDownload:(ASIHTTPRequest*)req{
    NSLog(@"图片%@ 有返回, ta的index是%@",[req.url absoluteString], req.username);
    int index = [req.username intValue];
    
    
    //NSLog(@"请求的状态码是%d", [req responseStatusCode] );
    NSData *imageDate = [req responseData];
    UIImage *image = [UIImage imageWithData:imageDate];
    if(image != nil){
        [imgf.images replaceObjectAtIndex:index withObject:image];
        [imgf loadData];
    }else{
        NSLog(@"         没有图片数据..................");
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void) loadArray{
    NSLog(@"imgf.images的长度是%d", [imgf.images count]);
    for (int i=0; i<[imgf.images count]; i++) {
        //TODO: 字符串的url地址才去下载, 调试方便可以去掉
        if ([[imgf.images objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [self download:[imgf.images objectAtIndex:i] withIndex:i];
        }
    }
}


-(void) didFinishRequest:(ASIHTTPRequest *)req{
    NSLog(@"图片%@ 有返回",[req.url absoluteString]);
    NSLog(@"请求的状态码是%d", [req responseStatusCode] );
    NSLog(@"%@", [req responseString]);
    NSDictionary* obj = [[req responseString] JSONValue];
    //获取服务器返回的数据, 此时这些图片都还是只是一个url
    imgf.images = [[NSMutableArray alloc] initWithArray:[obj objectForKey:@"flow"]];
    [imgf loadData];//首次渲染, 都是一些框框
    NSLog(@"flow 的长度是%d", [imgf.images count]);
    
    //好, 请求这些图片
    [self loadArray];
}


-(void)request{
    NSLog(@"异步获街道的flow数据");
    NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://%@/street/123/goodsList",webRoot]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    req.delegate = self;
    req.didFinishSelector = @selector(didFinishRequest:);
    req.didFailSelector = @selector(didFailRequest:);
    [req startSynchronous];
}
-(void) loadArrayAction:(id)sender{
    //[self loadArray];
    [self request];
}
- (void)viewDidLoad
{
    imgf = [[ImageFlow alloc] init];
    //发一个请求玩玩
    [self request];
    [self.view addSubview:imgf.view];
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
-(void) dealloc{
    [imgf release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
