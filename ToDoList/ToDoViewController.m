//
//  ToDoViewController.m
//  ToDoList
//
//  Created by AYA on 02/04/2024.
//

#import "ToDoViewController.h"
#import "AddTaskViewController.h"
#import "ShowTaskDetailsViewController.h"

@interface ToDoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filter;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property NSMutableArray * doneList, *inProgresList;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;
@property NSMutableArray<TaskPojo *> *searchedTasks;
@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = [NSMutableArray new];
    _lowPriorityList = [NSMutableArray new];
    _medPriorityList = [NSMutableArray new];
    _highPriorityList = [NSMutableArray new];
    _doneList = [NSMutableArray new];
    _searchedTasks =[NSMutableArray new];
    _inProgresList = [NSMutableArray new];
    self.search.delegate = self;
    self.emptyListLabel.hidden = YES;
    [self loadTasksFromUserDefaults];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *selectedList = [self selectedListForCurrentSegment];
    self.emptyListLabel.hidden = (selectedList.count > 0);
    if (self.searchedTasks.count > 0) {
           return self.searchedTasks.count;
       } else
           return selectedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
       NSArray *selectedList;
    if (self.searchedTasks.count > 0) {
            selectedList = self.searchedTasks;
        } else {
            selectedList = [self selectedListForCurrentSegment];
        }
       TaskPojo *task = selectedList[indexPath.row];
       cell.textLabel.text = task.name;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete item" message:@"Do you want to delete this item ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //NSArray *selectedList = [self selectedListForCurrentSegment];
            switch (self->_filter.selectedSegmentIndex) {
                case 0:
                    [self.tasks removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    [self.highPriorityList removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    [self.medPriorityList removeObjectAtIndex:indexPath.row];
                    break;
                case 3:
                    [self.lowPriorityList removeObjectAtIndex:indexPath.row];
                    break;
                default:
                    break;
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self saveData];
        }];
        UIAlertAction *cancel = [ UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:yes];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowTaskDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowTaskDetailsViewController"];
        NSArray<TaskPojo *> *selectedArray = [self selectedListForCurrentSegment];
        if (indexPath.row < selectedArray.count) {
            vc.task = selectedArray[indexPath.row];
            vc.taskIndex =(int) indexPath.row;
            vc.taskProtocol = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (IBAction)addNewTaskBtn:(id)sender {
    AddTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    vc.taskProtocol = self;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)addNewTask:(TaskPojo *)task{
    [self.tasks addObject:task];
    switch (task.taskPriority) {
        case 0:
            [_highPriorityList addObject:task];
            break;
        case 1:
            [_medPriorityList addObject:task];
            break;
        case 2:
            [_lowPriorityList addObject:task];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [self saveData];
    printf("Tasks count = %d \n", (int)_tasks.count);
}
- (void)updateTask:(TaskPojo *)task index:(int)index{
    
    switch(task.statue){
        case 1:
            [_tasks removeObjectAtIndex:index];
            [_inProgresList addObject:task];
            [self saveDoneList:_inProgresList key:@"InProgress"];
            break;
        case 2:
            [_tasks removeObjectAtIndex:index];
            [_doneList addObject:task];
            [self saveDoneList:_doneList key:@"DoneList"];
            break;
        default:
            [_tasks replaceObjectAtIndex:index withObject:task];
    }
    [self saveData];
    [self.tableView reloadData];
}
- (void)saveData {
    NSError *error = nil;
    //NSArray *objectArray = [NSArray arrayWithArray:_tasks];
    printf("_tasks count = %d \n", (int)_tasks.count);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
    if (data != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"TasksList"];
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
-(void) saveDoneList:(NSMutableArray *)list key: (NSString *) key{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    if (data != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
        if (success) {
            NSLog(@"Data saved successfully.");
        } else {
            NSLog(@"Failed to synchronize defaults.");
        }
    } 
}
-(void)loadTasksFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *tasksData = [defaults objectForKey:@"TasksList"];
    
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
- (IBAction)filterAction:(id)sender {
    [self.tableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSArray<TaskPojo *> *selectedList;
    NSLog(@"Search text changed: %@", searchText);
    if (searchText.length == 0) {
        selectedList = [self selectedListForCurrentSegment];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        selectedList = [[self selectedListForCurrentSegment] filteredArrayUsingPredicate:predicate];
    }
    // Set the filtered list as the new data source
    _searchedTasks = [selectedList mutableCopy];
    [self.tableView reloadData];
}

- (NSArray<TaskPojo *> *)selectedListForCurrentSegment {
    switch (_filter.selectedSegmentIndex) {
        case 0:
            return _tasks;
        case 1:
            return _highPriorityList;
        case 2:
            return _medPriorityList;
        case 3:
            return _lowPriorityList;
        default:
            return @[];
    }
}
@end
