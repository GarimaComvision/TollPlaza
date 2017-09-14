//
//  ReportViewCell.m
//  TollPlaza
//
//  Created by Comvision on 28/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "ReportViewCell.h"

@implementation ReportViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)imageClick:(UIButton *)sender {
    self.view.hidden=NO;
    
    NSString *str = [[_list objectAtIndex:sender.tag] valueForKey:@"ImageEvidence"];
    NSLog(@"String is %@",str);
    
    dispatch_async(dispatch_queue_create("imageQueue", NULL), ^{
        if ([str isEqual:nil]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[_list objectAtIndex:sender.tag] valueForKey:@"ImageEvidence"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.evidenceimageview setImage:image];
            });
        }
    });

}

- (IBAction)videoClick:(UIButton *)sender {

    self.view.hidden = NO;
    self.evidenceimageview.hidden = YES;
    NSString *Str = [[_list objectAtIndex:sender.tag] valueForKey:@"VideoEvidence"];
    if ([Str isEqualToString:@""]) {
        NSLog(@"No Video available");
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yourvideofile" ofType:@"mp4"];
        UIWebView *view = [[UIWebView alloc]initWithFrame:_evidenceimageview.frame];
        
      //  [view loadHTMLString:Str baseURL:[NSURL fileURLWithPath:path]];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Str]]];

        [self addSubview:view];
    }
  
//    MPMoviePlayerController *player =
//    [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:[[_list objectAtIndex:sender.tag] valueForKey:@"VideoEvidence"]]];
//    [player prepareToPlay];
//    [player.view setFrame: self.bounds];  // player's frame must match parent's
//    [self addSubview: player.view];
//    // ...
//    [player play];
}

- (IBAction)close:(id)sender {
    self.view.hidden=YES;
}

@end
