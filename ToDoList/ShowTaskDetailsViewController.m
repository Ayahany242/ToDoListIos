//
//  ShowTaskDetailsViewController.m
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import "ShowTaskDetailsViewController.h"
#import "TNRadioButtonGroup.h"
#import "TaskPojo.h"

@interface ShowTaskDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskNameTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySelected;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TaskStatue;


@end

@implementation ShowTaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (void)viewWillAppear:(BOOL)animated{
    //[self radioBtn];
    _taskNameTF.text =_task.name;
    _descriptionTF.text = _task.desc;
    _dateTime.text = _task.date;
    _prioritySelected.selectedSegmentIndex = _task.taskPriority;
    _TaskStatue.selectedSegmentIndex = _task.statue;
}
- (IBAction)updateTaskBtn:(id)sender {
    TaskPojo * t = [TaskPojo new];
    t.name = _taskNameTF.text;
     t.desc =_descriptionTF.text ;
    t.date = _dateTime.text ;
     t.taskPriority=(int)_prioritySelected.selectedSegmentIndex ;
    t.statue  =(int)_TaskStatue.selectedSegmentIndex;
    [_taskProtocol updateTask:t index:_taskIndex];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
