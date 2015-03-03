//
//  PMParentalGateQuestion.m
//  LanguageSkillBuilder
//
//  Created by Pawel Maczewski on 23/01/14.
//  Copyright (c) 2014 OwlCoding. All rights reserved.
//

#import "PMParentalGateQuestion.h"

@interface PMParentalGateQuestion ()
@property (nonatomic, assign) NSInteger selectedEquationIdx;
@property (nonatomic, copy) FinishedBlock finished;
@end

@implementation PMParentalGateQuestion


static PMParentalGateQuestion* __gate = nil;

+ (id) sharedGate
{
    @synchronized ( self ) {
        if (__gate == nil) {
            __gate = [[PMParentalGateQuestion alloc] init];
            
            __gate.equations = @[
                               @[@"2 x 9", @18],
                               @[@"8 x 5", @40],
                               @[@"6 x 6", @36],
                               @[@"5 x 9", @45],
                               @[@"7 x 3", @21],
                               @[@"7 x 6", @42],
                               ];

        }
    }
    return __gate;
}
- (void) timedoutForAlertView:(UIAlertView *) alertView
{
    self.finished ( NO, GR_TIMEOUT );
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        self.finished ( NO, GR_CANCEL );
        return;
    }
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        // check result
        int a = [[[alertView textFieldAtIndex:0] text] intValue];
        if (a == [self.equations[self.selectedEquationIdx][1] intValue]) {
            self.finished ( YES, GR_GOOD );
        } else {
            self.finished ( NO, GR_WRONG );
        }
    }
}

- (void) presentGateWithText:(NSString *) textQuestion  finishedBlock:(FinishedBlock) finished
{
    self.finished = finished;
    self.selectedEquationIdx = arc4random() % self.equations.count;
    
    UIAlertView *av =
    [[UIAlertView alloc] initWithTitle:@"Parental Gate"message:[NSString stringWithFormat:@"%@\n %@ = ",(nil == textQuestion ? @"Reaching an area restricted to parents" : textQuestion), self.equations[self.selectedEquationIdx][0]]delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Ok", nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[av textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [av show];

}

@end