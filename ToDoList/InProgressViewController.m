//
//  InProgressViewController.m
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import "InProgressViewController.h"
#import "ShowTaskDetailsViewController.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks =[NSMutableArray new];
    self.emptyListLabel.hidden = YES;
    [self loadTasksFromUserDefaults];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    TaskPojo *task = _tasks[indexPath.row];
    cell.textLabel.text = task.name;
    //cell.detailTextLabel.text = @"sds";
    switch (task.taskPriority) {
        case 0:
            cell.detailTextLabel.text = @"High Priority";
            break;
        case 1:
            cell.detailTextLabel.text = @"Medium Priority";
            break;
        case 2:
            cell.detailTextLabel.text = @"Low Priority";
            break;
        default:
            break;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.emptyListLabel.hidden = (_tasks.count > 0);
    return _tasks.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowTaskDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowTaskDetailsViewController"];
        vc.task = _tasks[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadTasksFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *tasksData = [defaults objectForKey:@"InProgress"];
    
    if (tasksData !=nil) {
        NSMutableArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:tasksData];
        printf("savedTasksData != nil \n");
        printf("savedTasksArray %d \n",(int)tasksArray.count);
        if ([tasksArray count] != 0) {
            printf("[tasksArray count] != 0 %d \n",(int)tasksArray.count);
            //[toDoList addObjectsFromArray:tasksArray];
            _tasks = [NSMutableArray arrayWithArray:tasksArray];
            [self.tableView reloadData];
        }
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete item" message:@"Do you want to delete this item ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //NSArray *selectedList = [self selectedListForCurrentSegment];
            [self.tasks removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self saveData];
        }];
        UIAlertAction *cancel = [ UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:yes];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
- (void)saveData {
    NSError *error = nil;
    //NSArray *objectArray = [NSArray arrayWithArray:_tasks];
    printf("_tasks count = %d \n", (int)_tasks.count);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
    if (data != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"InProgress"];
        BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
        if (success) {
            NSLog(@"Data saved successfully.");
        } else {
            NSLog(@"Failed to synchronize defaults.");
        }
    } else {
        NSLog(@"Error archiving data: %@", error.localizedDescription);
    }
}

@end
