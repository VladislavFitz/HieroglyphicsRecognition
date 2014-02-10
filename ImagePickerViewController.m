//
//  ImagePickerViewController.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 04.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController
@synthesize imageView = _imageView;

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSMutableArray * recognizers = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer * upRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                       action:@selector(imageUp:)];
    [upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    
    UISwipeGestureRecognizer * downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(imageDown:)];
    
    [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    UISwipeGestureRecognizer * leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(imageLeft:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer * rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(imageRight:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UIPinchGestureRecognizer * enlargeRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(imageEnlarge:)];
    [enlargeRecognizer setScale:2];
    
    [recognizers addObject:enlargeRecognizer];
    [recognizers addObject:upRecognizer];
    [recognizers addObject:downRecognizer];
    [recognizers addObject:leftRecognizer];
    [recognizers addObject:rightRecognizer];
    
    [_imageView setGestureRecognizers:recognizers];
}

-(IBAction)imageUp:(id)sender
{
    [self alert];
}

-(IBAction)imageDown:(id)sender
{
    [self alert];
}

-(IBAction)imageLeft:(id)sender
{
    [self alert];
}

-(IBAction)imageRight:(id)sender
{
    [self alert];
}

-(IBAction)imageEnlarge:(UIPinchGestureRecognizer *)recognizer
{
    [self alert];

    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 2;
}
-(void)alert
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"Ololo"
                                                 message:@"Trololo"
                                                delegate:self
                                       cancelButtonTitle:@"cancel"
                                       otherButtonTitles: nil];
    [av show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Actions
- (IBAction)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES
                         completion:nil];
        _newMedia = YES;
    }
}
- (IBAction)closeImagePicker:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}




@end
