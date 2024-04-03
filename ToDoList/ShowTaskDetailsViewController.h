//
//  ShowTaskDetailsViewController.h
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskPojo.h"
#import "NavigationProtocol.h"

@interface ShowTaskDetailsViewController : UIViewController
@property TaskPojo *task;
@property id<NavigationProtocol> taskProtocol;
@property int taskIndex;
@end

