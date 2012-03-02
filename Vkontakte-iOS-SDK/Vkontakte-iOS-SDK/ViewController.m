/*
 * Copyright 2010 Andrey Yastrebov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ViewController.h"
#import "NSString+Gender.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
    [self refreshButtonState];
}

- (void)refreshButtonState
{
    if (![_vkontakte isAuthorized]) 
    {
        [_loginB setTitle:@"Login" 
                 forState:UIControlStateNormal];
        [self hideControls:YES];
    } 
    else 
    {
        [_loginB setTitle:@"Logout" 
                 forState:UIControlStateNormal];
        [self hideControls:NO];
        [_vkontakte getUserInfo];
    }
}

- (void)hideControls:(BOOL)hide
{
    [_userImage setHidden:hide];
    [_userName setHidden:hide];
    [_userSurName setHidden:hide];
    [_userBDate setHidden:hide];
    [_userGender setHidden:hide];
    
    [_postMessage setHidden:hide];
    [_postImage setHidden:hide];
    [_postMessageWithLink setHidden:hide];
    [_postImageWithLink setHidden:hide];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)loginPressed:(id)sender
{
    if (![_vkontakte isAuthorized]) 
    {
        [_vkontakte authenticate];
    }
    else
    {
        [_vkontakte logout];
    }
}

- (IBAction)postMessagePressed:(id)sender
{
    [_vkontakte postMessageToWall:@"Test vk ios sdk"];
}

- (IBAction)postImagePressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"test_image"]];
}

- (IBAction)postMessageWithLinkPressed:(id)sender
{
    
}

- (IBAction)postImageWithLinkPressed:(id)sender
{
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    [self presentModalViewController:controller animated:YES];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    [self dismissModalViewControllerAnimated:YES];
    [self refreshButtonState];
}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    [self refreshButtonState];
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    
    NSString *photoUrl = [info objectForKey:@"photo_big"];
    NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
    _userImage.image = [UIImage imageWithData:photoData];
    
    _userName.text = [info objectForKey:@"first_name"];
    _userSurName.text = [info objectForKey:@"last_name"];
    _userBDate.text = [info objectForKey:@"bdate"];
    _userGender.text = [NSString stringWithGenderId:[[info objectForKey:@"sex"] intValue]];
    _userEmail.text = [info objectForKey:@"email"];
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    NSLog(@"%@", responce);
}

@end
