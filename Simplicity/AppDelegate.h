//
//  AppDelegate.h
//  EnjoySplicing
//
//  Created by enjoy on 2019/5/29.
//  Copyright © 2019 EnjoySplicing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

