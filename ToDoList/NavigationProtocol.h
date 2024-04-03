//
//  NavigationProtocol.h
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import <Foundation/Foundation.h>
#import "TaskPojo.h"


@protocol NavigationProtocol <NSObject>

-(void) addNewTask:(TaskPojo *) task;
-(void) updateTask:(TaskPojo *) task index:(int) index;

@end

