//
//  ImagePickerViewController.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 04.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ImagePickerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL newMedia;


@end
