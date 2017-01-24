//
//  ViewController.m
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "ViewController.h"
#import "WikiQuizContent.h"
#import "OptionsTableViewCell.h"
#import "STPopup/STPopup.h"
#import "PopupViewController.h"

@interface ViewController ()
{
    TextDownloader *TD;
    WikiQuizContent *WQC;
    NSRange selectedBlankCharacterRange;
    NSInteger selectedBlankIndex;
    NSMutableDictionary *seletedAnswers;

}


@end

@implementation ViewController


- (IBAction)SubmitQuizAnswer:(id)sender {

    int marks=0;
    for (int i=0; i<[WQC.answerRanges count]; i++) {
        if ([[WQC.answers objectAtIndex:i] isEqualToString:[seletedAnswers valueForKey:[NSString stringWithFormat:@"%d",i]]]) {
            marks++;
        }
    }
    
    /*UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Score Card" message: [NSString stringWithFormat:@"You Got %d Marks",marks] delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    UIImage* imgMyImage = [UIImage imageNamed:@"pass.png"];
    UIImageView* ivMyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgMyImage.size.width, 100)];
    [ivMyImageView setImage:imgMyImage];
    
    [alert setValue: ivMyImageView forKey:@"accessoryView"];
    [alert show];
    
    */
    /*
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Title"
                                  message:@"Welcome"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Do some thing here
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   [self.RefreshQuiz sendActionsForControlEvents:UIControlEventTouchUpInside];
                                   

   // [okButton setValue:[[UIImage imageNamed:@"pass.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
*/
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[PopupViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    if (NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        popupController.backgroundView.alpha = 0.8; // This is not necessary
    }
    [popupController presentInViewController:self];
    
}


- (IBAction)RefreshQuiz:(id)sender {
    
    //Enabling the buttons
    self.RefreshQuiz.enabled=false;
    self.Submit.enabled=false;
    
    seletedAnswers=nil;
    WQC=nil;
    self.WikiTextView.text=nil;
    [self rotateLayerInfinite:self.ActivityIndicatorImage.layer];
    [self HideOptionsTableView];
    [TD DownloadData];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.WikiTextView.text=nil;
    [self.WikiTextView setEditable:NO];
    self.WikiTextView.delegate = self;
    
    //Disabling the buttons
    self.RefreshQuiz.enabled=false;
    self.Submit.enabled=false;
    
    [self rotateLayerInfinite:self.ActivityIndicatorImage.layer];
    [self rotateLayerInfinite:self.RefreshQuiz.layer];
    
    
    self.optionsTableView.delegate=self;
    self.optionsTableView.dataSource=self;
    self.optionsTableView.layer.cornerRadius=10;
    self.optionsTableView.clipsToBounds = YES;
    self.optionsTableView.layer.borderWidth = 2.0;
    self.optionsTableView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.optionsTableView.separatorColor = [UIColor whiteColor];
    

    TD=[TextDownloader sharedInstance];
    [TD DownloadData];
    TD.delegate=self;
    

}




- (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(-2 * M_PI)];
    rotation.duration = 1.0f; 
    rotation.repeatCount = HUGE_VALF;
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}



-(void)DownLoadCompletedWithData:(NSString *)WikiString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //Enabling the buttons
        self.RefreshQuiz.enabled=true;
        self.Submit.enabled=true;

        WQC= [TextParser ParseWikiText:WikiString];
        [self.ActivityIndicatorImage.layer removeAllAnimations];
        [self AddBlankstoWikiText:WQC.wikiText];
        seletedAnswers=[[NSMutableDictionary alloc] init];
        [self.optionsTableView reloadData];
    });
    
}


-(void)AddBlankstoWikiText:(NSString*)wikiText
{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:wikiText];
    
    UIFont *font = [UIFont fontWithName:@"Palatino-Roman" size:15.0];
    [attributedString setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, [wikiText length])];
    
    
    for (int i=(int)[WQC.answerRanges count]; i>0; i--) {
        
        [attributedString addAttribute:NSLinkAttributeName
                                 value:[NSString stringWithFormat:@"answer://%d",i]
                                 range:[WQC.answerRanges[i-1] rangeValue]];
        
        [attributedString replaceCharactersInRange:[[WQC.answerRanges objectAtIndex:i-1] rangeValue] withString:[NSString stringWithFormat:@"#%d_____",i]];
        
        }
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    self.WikiTextView.linkTextAttributes = linkAttributes;
    self.WikiTextView.attributedText = attributedString;

}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"answer"]) {
        NSString *answerNo = [URL host];
        selectedBlankIndex=[answerNo integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ShowOptionsTableView];
            selectedBlankCharacterRange=characterRange;

        });
        return NO;
    }
    return NO; // let the system open this URL
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (WQC) {
        return [WQC.shuffledOptions count];
    }
    else
    {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OptionsTableViewCell"];
    if (cell==nil) {
        cell=[[OptionsTableViewCell alloc] init];
    }
    if (WQC) {
        cell.option.text=[WQC.shuffledOptions objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableAttributedString *sampleText = [[NSMutableAttributedString alloc] initWithAttributedString:self.WikiTextView.attributedText];

    [sampleText replaceCharactersInRange:selectedBlankCharacterRange withString:[NSString stringWithFormat:@"#%ld %@",(long)selectedBlankIndex,[WQC.shuffledOptions objectAtIndex:indexPath.row]]];
    
    [seletedAnswers setValue:[WQC.shuffledOptions objectAtIndex:indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)selectedBlankIndex]];

    self.WikiTextView.attributedText=sampleText;
    [self HideOptionsTableView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)ShowOptionsTableView{
    
    if (self.optionsTableView.frame.size.height == 0) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.optionsTableView.frame;
                             if ([WQC.shuffledOptions count]*40 > self.view.frame.size.height/2) {
                                 frame.origin.y= frame.origin.y-self.view.frame.size.height/2;
                                 frame.size.height = self.view.frame.size.height/2;
                                 self.optionsTableView.frame = frame;
                             }
                             else
                             {
                                 frame.origin.y= frame.origin.y-[WQC.shuffledOptions count]*40;
                                 frame.size.height = [WQC.shuffledOptions count]*40;
                                 self.optionsTableView.frame = frame;
                                 
                             }
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }


}

-(void)HideOptionsTableView{


    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.optionsTableView.frame;
                         frame.origin.y= frame.origin.y+frame.size.height;
                         frame.size.height = 0;
                         self.optionsTableView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];

}


@end
