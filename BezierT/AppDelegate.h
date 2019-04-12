//
//  AppDelegate.h
//  BezierT
//
//  Created by LiuJianning on 2019/4/12.
//  Copyright © 2019 1231. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

