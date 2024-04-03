//
//  ToDoViewController.h
//  ToDoList
//
//  Created by AYA on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"
#import "TaskPojo.h"

@interface ToDoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NavigationProtocol,UISearchBarDelegate>
@property NSMutableArray *tasks;
@property NSMutableArray *lowPriorityList , *medPriorityList,*highPriorityList;
@property NSUserDefaults *defaults;
@end
