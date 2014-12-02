//
//  ViewController.m
//  PassbookDemo
//
//  Created by Kitten Yang on 14/12/1.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ViewController.h"

#define MAXHEIGHT  [UIScreen  mainScreen].bounds.size.height

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;

@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) NSArray *animationConstraints;

@end

@implementation ViewController{
    BOOL _willAnimate;
    NSInteger animationIndex;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageViewList = [NSMutableArray arrayWithCapacity:5];
    [self.imageViewList addObject:self.view1];
    [self.imageViewList addObject:self.view2];
    [self.imageViewList addObject:self.view3];
    [self.imageViewList addObject:self.view4];
    [self.imageViewList addObject:self.view5];
    
    for (int i = 0; i<self.imageViewList.count; i++) {
        UIView *cView = self.imageViewList[i];
        cView.backgroundColor = [UIColor colorWithRed:233/255.0 green:(35 + 30*i)/255.0 blue:29/255.0 alpha:1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap:)];
        [self.imageViewList[i] addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(Pan:)];
        [self.imageViewList[i] addGestureRecognizer:pan];
    
    }
    

}



#pragma mark - UITapGestureRecognizer Action
-(void)Tap:(UITapGestureRecognizer *)gesture{
    animationIndex = gesture.view.tag;
    [self animate:animationIndex];
}


#pragma mark - UIPanGestureRecognizer Action
-(void)Pan:(UIPanGestureRecognizer *)gesture{

    animationIndex = [gesture view].tag;
    CGPoint point = [gesture translationInView:[gesture view]]; // 距离手指刚按下去时的那个起始点的偏移量

    //向上拖动
    if(point.y < 0){
        [self.view removeConstraints:_animationConstraints];
        NSString *VisualFormal = @"V:|";
        for (int i = 0; i < self.imageViewList.count; ++i) {
            NSString *key = [@"view" stringByAppendingString:[@(i) stringValue]];
            NSString *value = [NSString stringWithFormat:@"-0-[%@(67)]", key];
            if (i == 0) {
                value = [NSString stringWithFormat:@"-(%f)-[%@(67)]", MAXHEIGHT - 5*67 + point.y,key];
            }
            if (i == animationIndex) {
                value = [NSString stringWithFormat:@"-0-[%@(%f)]", key, 67-point.y];
            }
            if (i == animationIndex && i==0) {
                value = [NSString stringWithFormat:@"-(%f)-[%@(%f)]",(MAXHEIGHT-5*67)+point.y,key,67-point.y];
            }
            
            VisualFormal = [VisualFormal stringByAppendingString:value];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.view1,@"view0",
                             self.view2,@"view1",
                             self.view3,@"view2",
                             self.view4,@"view3",
                             self.view5,@"view4",nil];

        
        self.animationConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:VisualFormal
                                                options:0
                                                metrics:nil
                                                  views:dic];
        [self.view addConstraints:self.animationConstraints];
    }
    
    //向下拖动
    if ( point.y > 0 ) {
        [self.view removeConstraints:_animationConstraints];
        NSString *VisualFormal = @"V:|";
        for (int i = 0; i < self.imageViewList.count; i++) {
            NSString *key = [@"view" stringByAppendingString:[@(i) stringValue]];
            NSString *value = [NSString stringWithFormat:@"-0-[%@(67)]", key];
            if (i == 0){
                value = [NSString stringWithFormat:@"-(%f)-[%@(67)]", -67*animationIndex + point.y,key];
            }
            if (i == animationIndex) {
                value = [NSString stringWithFormat:@"-0-[%@(%f)]",key,MAXHEIGHT-point.y];
            }
            if (i == animationIndex && i == 0) {
                value = [NSString stringWithFormat:@"-(%f)-[%@(%f)]",point.y,key,MAXHEIGHT + point.y];
            }
            VisualFormal = [VisualFormal stringByAppendingString:value];
        }

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.view1,@"view0",
                             self.view2,@"view1",
                             self.view3,@"view2",
                             self.view4,@"view3",
                             self.view5,@"view4",nil];
        
        
        self.animationConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:VisualFormal
                                                options:0
                                                metrics:nil
                                                  views:dic];
        
        [self.view addConstraints:self.animationConstraints];

    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        if (point.y <= -40) {
            [self animate:animationIndex];
        }
        if (point.y >= 40) {
            [self animate:animationIndex];
        }
        
    }

}



#pragma mark - general method
- (void)reset
{
    [self.view removeConstraints:_animationConstraints];
    NSString *VisualFormal = @"V:";
    for (int i = 0; i < self.imageViewList.count; i++) {
        NSString *key = [@"view" stringByAppendingString:[@(i) stringValue]];
        NSString *value = [NSString stringWithFormat:@"[%@(67)]-0-", key];
        VisualFormal = [VisualFormal stringByAppendingString:value];
    }
    VisualFormal = [VisualFormal stringByAppendingString:@"|"];
    NSLog(@"%@",VisualFormal);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.view1,@"view0",
                                                                   self.view2,@"view1",
                                                                   self.view3,@"view2",
                                                                   self.view4,@"view3",
                                                                   self.view5,@"view4",nil];

    
    self.animationConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:VisualFormal
                                            options:0
                                            metrics:nil
                                              views:dic];
    
    [self.view addConstraints:self.animationConstraints];
}


-(void)animate:(NSInteger)index{
    
    NSInteger _index = index;
    
    if (!_willAnimate) {
        
        _willAnimate = YES;
        
        [UIView animateWithDuration:.3f
                         animations:^{
                             [self.view removeConstraints:_animationConstraints];
                             NSString *VisualFormal = @"V:|";
                             for (int i = 0; i < self.imageViewList.count; ++i) {
                                 NSString *key = [@"view" stringByAppendingString:[@(i) stringValue]];
                                 NSString *value = [NSString stringWithFormat:@"-0-[%@(67)]", key];
                                 if (i == 0) {
                                     value = [NSString stringWithFormat:@"-(-%ld)-[%@(67)]", 67 * _index,key];
                                 }
                                 if (i == _index) {
                                     value = [NSString stringWithFormat:@"-0-[%@(%f)]", key, MAXHEIGHT];
                                 }
                                 
                                 VisualFormal = [VisualFormal stringByAppendingString:value];
                             }

                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.view1,@"view0",
                                          self.view2,@"view1",
                                          self.view3,@"view2",
                                          self.view4,@"view3",
                                          self.view5,@"view4",nil];
                             NSLog(@"---------%@",VisualFormal);
                             
                             self.animationConstraints =
                             [NSLayoutConstraint constraintsWithVisualFormat:VisualFormal
                                                                     options:0
                                                                     metrics:nil
                                                                       views:dic];
                             [self.view addConstraints:self.animationConstraints];
                                 
                             
                             [self.view layoutIfNeeded];
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [self.view removeConstraints:_animationConstraints];
                             [self reset];
                             [self.view layoutIfNeeded];
                         }];
        
        _willAnimate = NO;
    }
    
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
