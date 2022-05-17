//
//  NSObject+UdeskAVS.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UdeskAVS)


- (void)setAssociateValue:(id)value withKey:(void *)key;

- (void)setAssociateCopyValue:(id)value withKey:(void *)key;

- (void)setAssociateWeakValue:(id)value withKey:(void *)key;

- (void)removeAssociatedValues;

- (id)getAssociatedValueForKey:(void *)key;


@end

NS_ASSUME_NONNULL_END
