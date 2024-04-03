//
//  AddTaskViewController.m
//  ToDoList
//
//  Created by AYA on 02/04/2024.
//

#import "AddTaskViewController.h"
#import "TNRadioButtonGroup.h"
#import "TaskPojo.h"

@interface AddTaskViewController ()

@property TNRadioButtonGroup *radioButtonGroup;
@property TaskPojo *task;
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self radioBtn];
    _task = [[TaskPojo alloc] init];
}

-(void) radioBtn{
    TNCircularRadioButtonData *highPriority = [TNCircularRadioButtonData new];
    highPriority.labelText = @"High";
    highPriority.identifier = @"high";
    highPriority.selected = YES;
    highPriority.borderColor = [UIColor blackColor];
    highPriority.circleColor = [UIColor blackColor];
    highPriority.borderRadius = 16;
    highPriority.circleRadius = 8;
    TNCircularRadioButtonData *mediumPriority = [TNCircularRadioButtonData new];
    mediumPriority.labelText = @"Medium";
    mediumPriority.identifier = @"medium";
    mediumPriority.borderColor = [UIColor blackColor];
    mediumPriority.circleColor = [UIColor blackColor];
    mediumPriority.borderRadius = 16;
    mediumPriority.circleRadius = 8;
    TNCircularRadioButtonData *lowPriority = [TNCircularRadioButtonData new];
    lowPriority.labelText = @"Low";
    lowPriority.identifier = @"low";
    lowPriority.borderColor = [UIColor blackColor];
    lowPriority.circleColor = [UIColor blackColor];
    lowPriority.borderRadius = 16;
    lowPriority.circleRadius = 8;

    self.radioButtonGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[highPriority,mediumPriority,lowPriority] layout:TNRadioButtonGroupLayoutHorizontal];
    
    self.radioButtonGroup.marginBetweenItems = 24;
    self.radioButtonGroup.identifier = @"My group";
    [self.radioButtonGroup create];
    self.radioButtonGroup.position = CGPointMake(75, 380);
    [self.view addSubview:self.radioButtonGroup];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myGroupGotUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.radioButtonGroup];

    
}
- (void)myGroupGotUpdated:(NSNotification *)notification {
    TNRadioButtonData *selectedRadioButtonData = self.radioButtonGroup.selectedRadioButton.data;
    NSLog(@"radioButtonGroup Priority Identifier: %@ \n", self.radioButtonGroup.selectedRadioButton.data);
    _task.taskPriority =  (int)selectedRadioButtonData.tag;
    NSLog(@"Selected Radio Button Identifier: %d",(int) _task.taskPriority);
}

- (IBAction)addTaskBtn:(id)sender {
    
    if(_taskNameLabel.text != nil){
        _task.name =_taskNameLabel.text;
    }
    if(_descriptionLabel.text != nil){
        _task.desc = _descriptionLabel.text;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    _task.date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", _task.date);
    _task.statue = 0;
    [self.taskProtocol addNewTask:_task];
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
