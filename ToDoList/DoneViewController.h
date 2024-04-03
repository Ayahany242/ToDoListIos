//
//  ViewController.h
//  ToDoList
//
//  Created by AYA on 02/04/2024.
//

#import <UIKit/UIKit.h>

@interface DoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *tasks;

@end

