//
//  AddTaskViewController.h
//  ToDoList
//
//  Created by AYA on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"
#import "TaskPojo.h"

@interface AddTaskViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextField *taskNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property id<NavigationProtocol> taskProtocol;

@end
