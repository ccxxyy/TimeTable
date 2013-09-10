//
//  DetailViewController.h
//  TimeTable
//
//  Created by Xiaoyi Cai on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController{
    // store the value which is set in former class
    NSDictionary *moduleDetail;
    // define a label
    UILabel *titleLabel;
    // define a text view
    UITextView *textView;
    
    //NSDictionary *selectModule;
}


@property (nonatomic, retain) NSDictionary *moduleDetail;
@property (nonatomic, retain) IBOutlet UILabel *moduleLabel;
@property (nonatomic, retain) IBOutlet UITextView *textView;



@end
