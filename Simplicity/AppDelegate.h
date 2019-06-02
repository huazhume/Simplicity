//
//  AppDelegate.h
//  Simplicity
//
//  Created by xiaobai zhang on 2019/5/29.
//  Copyright © 2019 Simplicity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

