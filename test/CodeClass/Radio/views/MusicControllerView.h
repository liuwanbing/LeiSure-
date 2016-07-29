//
//  MusicControllerView.h
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicControllerView : UIView

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *PlayAndPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
