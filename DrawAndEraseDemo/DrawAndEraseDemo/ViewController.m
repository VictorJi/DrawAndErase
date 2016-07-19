//
//  ViewController.m
//  DrawAndEraseDemo
//
//  Created by Victor Ji on 16/7/8.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "ViewController.h"
#import "DoodleDrawView.h"

@interface ViewController () <DoodleDrawViewDelegate>

@property (strong, nonatomic) DoodleDrawView *drawView;
@property (assign, nonatomic) BOOL drawStart;

@property (weak, nonatomic) IBOutlet UITextField *xTextField;
@property (weak, nonatomic) IBOutlet UITextField *yTextField;
@property (weak, nonatomic) IBOutlet UIButton *startEndDrawButton;

- (IBAction)drawButtonClickAction:(id)sender;
- (IBAction)eraseButtonClickAction:(id)sender;
- (IBAction)cleanButtonClickAction:(id)sender;
- (IBAction)startEndDrawButtonClickAction:(id)sender;
- (IBAction)DrawLineButtonClickAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.drawView = [[DoodleDrawView alloc] init];
    self.drawView.lineColor = [UIColor redColor];
    self.drawView.lineWidth = 4.0f;
    self.drawView.eraseWidth = 16.0f;
    self.drawView.backgroundColor = [UIColor yellowColor];
    self.drawView.frame = self.view.bounds;
    self.drawView.delegate = self;
    [self.view addSubview:self.drawView];
    [self.view sendSubviewToBack:self.drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)drawButtonClickAction:(id)sender {
    self.drawView.type = DrawTypeDraw;
}

- (IBAction)eraseButtonClickAction:(id)sender {
    self.drawView.type = DrawTypeErase;
}

- (IBAction)cleanButtonClickAction:(id)sender {
    [self.drawView cleanDoodles];
}

- (IBAction)startEndDrawButtonClickAction:(id)sender {
    [self.xTextField resignFirstResponder];
    [self.yTextField resignFirstResponder];
    if ([self checkValidate]) {
        CGPoint point = [self makePoint];
        if (self.drawStart) {
            [self.startEndDrawButton setTitle:@"StartDraw" forState:UIControlStateNormal];
            [self.drawView drawFinishToPoint:point];
        } else {
            [self.startEndDrawButton setTitle:@"EndDraw" forState:UIControlStateNormal];
            [self.drawView startDraw:DrawTypeDraw drawWidth:5.0f drawColor:[UIColor greenColor] startPoint:point];
        }
        self.drawStart = !self.drawStart;
    } else {
        [self showAlert];
    }
}

- (IBAction)DrawLineButtonClickAction:(id)sender {
    [self.xTextField resignFirstResponder];
    [self.yTextField resignFirstResponder];
    if ([self checkValidate]) {
        CGPoint point = [self makePoint];
        [self.drawView drawToPoint:point];
    } else {
        [self showAlert];
    }
}

- (BOOL)checkValidate {
    NSString *xStr = self.xTextField.text;
    NSString *yStr = self.yTextField.text;
    if ([xStr integerValue] > 0 && [yStr integerValue] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (CGPoint)makePoint {
    NSString *xStr = [NSString stringWithFormat:@"0.%@", self.xTextField.text];
    NSString *yStr = [NSString stringWithFormat:@"0.%@", self.yTextField.text];
    CGFloat x = [xStr floatValue];
    CGFloat y = [yStr floatValue];
    return CGPointMake(x, y);
}

- (void)showAlert {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Invalid input" message:@"Please verify your input" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
