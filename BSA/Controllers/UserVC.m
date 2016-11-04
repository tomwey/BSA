//
//  UserVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "UserVC.h"
#import "Defines.h"

@interface UserVC () <UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) UIImageView *avatarView;

@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.title = @"用户信息";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    self.tableView.rowHeight  = 60;
    
    [self.tableView removeBlankCells];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.user = [[UserService sharedInstance] currentUser];
    
    [self.tableView reloadData];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = indexPath.section == 0 ? @"cell.id" : @"cell.id2";
    UITableViewCellStyle style = indexPath.section == 0 ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            cell.textLabel.text = @"头像";
            UIImageView *avatarView = (UIImageView *)[cell.contentView viewWithTag:1011];
            if ( !avatarView ) {
                avatarView = AWCreateImageView(nil);
                avatarView.frame = CGRectMake(0, 0, 48, 48);
                [cell.contentView addSubview:avatarView];
                avatarView.tag = 1011;
                
                avatarView.cornerRadius = avatarView.height / 2;
                
                avatarView.center = CGPointMake(self.contentView.width - 20 - 15 - avatarView.width / 2,
                                                self.tableView.rowHeight / 2 );
            }
            
            [avatarView setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
            
            self.avatarView = avatarView;
        } else if ( indexPath.row == 1 ) {
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = [self.user formatUsername];
        } else if ( indexPath.row == 2 ) {
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [self.user formatSex];
        } else if ( indexPath.row == 3 ) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [self.user formatBirth];
        }
    } else {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            // 修改头像
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", @"选择图片", nil];
            [as showInView:self.contentView];
        } else if ( indexPath.row == 1 ) {
            // 设置用户名
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"UpdateNicknameVC" params:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ( indexPath.row == 2 ) {
            // 设置性别
            [[[SexPicker alloc] init] showInView:self.contentView selectedBlock:^(SexPicker *sender, id selectedObj) {
                NSLog(@"selected sex: %@", selectedObj);
                
                [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                
                [[UserService sharedInstance] updateUserProfile:@{ @"key": @"sex", @"value": [selectedObj valueForKey:@"value"] } completion:^(User *aUser, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
                    
                    if ( !error ) {
                        [self.contentView makeToast:@"性别设置成功" duration:2.0 position:CSToastPositionTop];
                        
                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        cell.detailTextLabel.text = selectedObj[@"label"];
                    } else {
                        [self.contentView makeToast:@"性别设置失败" duration:2.0 position:CSToastPositionTop];
                    }
                }];
            }];
        } else if ( indexPath.row == 3 ) {
            // 设置生日
            [[[DatePicker alloc] init] showInView:self.contentView selectedBlock:^(DatePicker *sender, NSDate *selectedDate) {
                NSLog(@"date: %@", selectedDate);
                
                [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                df.dateFormat = @"yyyy-MM-dd";
                
                [[UserService sharedInstance] updateUserProfile:@{ @"key": @"birthday", @"value": selectedDate } completion:^(User *aUser, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
                    
                    if ( !error ) {
                        [self.contentView makeToast:@"生日设置成功" duration:2.0 position:CSToastPositionTop];
                        
                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        cell.detailTextLabel.text = [df stringFromDate:selectedDate];

                    } else {
                        [self.contentView makeToast:@"生日设置失败" duration:2.0 position:CSToastPositionTop];
                    }
                }];
                
            }];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"退出登录" message:@"你确定吗？"
                                  delegate:self
                         cancelButtonTitle:nil
                          otherButtonTitles:@"确定",@"取消", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        [[UserService sharedInstance] logout:^(id result, NSError *error) {
            if ( !error ) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.delegate      = self;
    }
    return _imagePickerController;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        // 拍照
        if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            [self showAlertWithMessage:@"设备不支持拍照"];
            return;
        }
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ( buttonIndex == 1 ) {
        // 选择图片
        if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
            [self showAlertWithMessage:@"设备不支持该功能"];
            return;
        }
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if ( buttonIndex < 2 ) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)showAlertWithMessage:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"提示"
                               message:msg delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil] show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
//    self.avatarView.image = editedImage;
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageString =
    [UIImagePNGRepresentation(editedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSLog(@"imageString: \n%@", imageString);
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [[UserService sharedInstance] updateAvatar:@{ @"image": imageString }
                                    completion:^(User *aUser, NSError *error) {
                                        [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
                                        if ( !error ) {
                                            [self.contentView makeToast:@"头像设置成功" duration:2.0 position:CSToastPositionTop];
                                            
                                            self.user = aUser;
                                            
                                            [self.tableView reloadData];
                                        } else {
                                            [self.contentView makeToast:@"头像设置失败" duration:2.0 position:CSToastPositionTop];
                                        }
                                    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
