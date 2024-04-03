//
//  InProgressViewController.h
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskPojo.h"

@interface InProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *tasks;
@end

