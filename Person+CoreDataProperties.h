//
//  Person+CoreDataProperties.h
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<BarrowItem *> *barrowItem;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addBarrowItemObject:(BarrowItem *)value;
- (void)removeBarrowItemObject:(BarrowItem *)value;
- (void)addBarrowItem:(NSSet<BarrowItem *> *)values;
- (void)removeBarrowItem:(NSSet<BarrowItem *> *)values;

@end

NS_ASSUME_NONNULL_END
