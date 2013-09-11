//
//  LMGameControllerManager.h
//  SiOS
//
//  Created by Dan Leehr on 9/11/13.
//  Copyright (c) 2013 Lucas Menge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMGameControllerManager : NSObject

// Not yet implemented
@property (nonatomic, getter = isEnabled) BOOL enabled;

+ (LMGameControllerManager *)sharedManager;

@end
