//
//  ActionSheetPickView.m
//  ActionSheetPickView
//
//  Created by Deng Jun on 15/12/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//
#define ZHToobarHeight 40
#define kPickViewHeight 220

#import "ActionSheetPickView.h"

@interface ActionSheetPickView () <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *plistName;
@property (nonatomic, strong) NSArray *plistArray;
@property (nonatomic, assign) BOOL isLevelArray;
@property (nonatomic, assign) BOOL isLevelString;
@property (nonatomic, assign) BOOL isLevelDic;
@property (nonatomic, strong) NSDictionary *levelTwoDic;
@property (nonatomic, strong) UIView *pickerViewContainer;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) NSDate *defaulDate;
@property (nonatomic, assign) BOOL isHaveNavControler;
@property (nonatomic, assign) NSInteger pickeviewHeight;
@property (nonatomic, copy) NSString *resultString;
@property (nonatomic, strong) NSMutableArray *componentArray;
@property (nonatomic, strong) NSMutableArray *dicKeyArray;
@property (nonatomic, copy) NSMutableArray *state;
@property (nonatomic, copy) NSMutableArray *city;

@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;
// 点击背景取消
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ActionSheetPickView

+ (ActionSheetPickView *)sharedPickView
{
    static ActionSheetPickView *pickView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        pickView = [[ActionSheetPickView alloc] initWithFrame:rect];
    });
    
    return pickView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)dealloc{
    [self removeGestureRecognizer:_tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
    
    if (!CGRectContainsPoint(_pickerViewContainer.frame, touchPoint)) {
        [self dismiss];
    }
}

- (NSArray *)plistArray{
    if (_plistArray == nil) {
        _plistArray = [[NSArray alloc] init];
    }
    return _plistArray;
}

- (NSArray *)componentArray{

    if (_componentArray == nil) {
        _componentArray = [[NSMutableArray alloc] init];
    }
    return _componentArray;
}

- (instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self = [ActionSheetPickView sharedPickView];
    if (self) {
        _plistName = plistName;
        self.plistArray = [self getPlistArrayByplistName:plistName];
    }
    return self;
}

- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self = [ActionSheetPickView sharedPickView];
    if (self) {
        self.plistArray = array;
        [self setArrayClass:array];
    }
    return self;
}

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    self = [ActionSheetPickView sharedPickView];
    if (self) {
        _defaulDate = defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
    }
    return self;
}


- (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

- (void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        } else if ([levelTwo isKindOfClass:[NSString class]]) {
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        } else if ([levelTwo isKindOfClass:[NSDictionary class]]) {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

- (void)setUpPickView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ActionSheetPickView" owner:self options:nil];
    _pickerViewContainer = [arr objectAtIndex:0];
    _pickerViewContainer.frame = CGRectMake(0, SCREEN_HEIGHT - kPickViewHeight, SCREEN_WIDTH, kPickViewHeight);
    
    UIPickerView *pickView = [_pickerViewContainer viewWithTag:1003];
    pickView.delegate = self;
    pickView.dataSource = self;
    _pickerView = pickView;
    
    UIButton *cancelBtn = [_pickerViewContainer viewWithTag:1001];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *okBtn = [_pickerViewContainer viewWithTag:1002];
    [okBtn addTarget:self action:@selector(doneClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:_pickerViewContainer];
}

- (void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor = [UIColor lightGrayColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker = datePicker;
    datePicker.frame = CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickeviewHeight = datePicker.frame.size.height;
    [self addSubview:datePicker];
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
                if ([dicValue isKindOfClass:[NSArray class]]) {
                    if (component%2==1) {
                        rowArray=dicValue;
                    }else{
                        rowArray=_plistArray;
                    }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
        
    } else if (_isLevelString) {
        rowTitle=_plistArray[row];
        
    } else if (_isLevelDic) {
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic =_plistArray[pIndex];
        if(component%2 == 0) {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
           if ([aa isKindOfClass:[NSArray class]] && component%2 == 1) {
                NSArray *bb = aa;
                if (bb.count > row) {
                    rowTitle = aa[row];
                }
            }
        }
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    } else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                          }
        }
        
    } else if (_isLevelDic){
        if (component==0) {
          _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

- (void)remove {
    [self removeFromSuperview];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    [self setUpPickView];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
    [_pickerViewContainer.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
    [CATransaction commit];
    
}

- (void)dismiss {
    if ([self superview]) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setCompletionBlock:^{
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
        [_pickerViewContainer.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
        [CATransaction commit];
    }
}

#pragma mark -

- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:150.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        //        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setAnimations:@[positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:150.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        //        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setAnimations:@[positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

- (void)doneClick {
    if (_pickerViewContainer) {
        if (_isLevelString) {
            _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            
        } else if (_isLevelArray) {
            _resultString=@"";
            for (int i=0; i<_plistArray.count;i++) {
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
            
        } else if (_isLevelDic) {
            if (_state == nil) {
                _state =_dicKeyArray[0][0];
                NSDictionary *dicValueDic=_plistArray[0];
                _city=[dicValueDic allValues][0][0];
            }
            if (_city == nil){
                NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                NSDictionary *dicValueDic=_plistArray[cIndex];
                _city=[dicValueDic allValues][0][0];
                
            }
            _resultString=[NSString stringWithFormat:@"%@ - %@",_state,_city];
            _state = nil;
            _city = nil;
        }
        
    } else if (_datePicker) {
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(toolbarDonBtnHaveClick:resultString:)]) {
        [self.delegate toolbarDonBtnHaveClick:self resultString:_resultString];
    }
    
    [self dismiss];
}

@end
