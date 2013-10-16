//
//  AppDelegate.h
//  DBM
//
//  Created by Baitian on 13-5-14.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@class UnitDAO;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UnitDAO* test_dao;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController* viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
