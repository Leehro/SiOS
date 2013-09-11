//
//  LMGameControllerManager.m
//  SiOS
//
//  Created by Dan Leehr on 9/11/13.
//  Copyright (c) 2013 Lucas Menge. All rights reserved.
//

#import "LMGameControllerManager.h"
#import <GameController/GameController.h>
#import "SNES9XBridge/Snes9xMain.h"

void handleButtonChange(long button, BOOL pressed);


@implementation LMGameControllerManager

+ (LMGameControllerManager *)sharedManager {
    static LMGameControllerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LMGameControllerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDidConnect:)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDidDisconnect:)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)installHandlers:(GCController *)controller {
    controller.gamepad.buttonA.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_A, pressed); };
    controller.gamepad.buttonB.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_B, pressed); };
    controller.gamepad.buttonX.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_X, pressed); };
    controller.gamepad.buttonY.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_Y, pressed); };
    controller.gamepad.leftShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_L, pressed); };
    controller.gamepad.rightShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_R, pressed); };
    controller.gamepad.dpad.up.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_UP, pressed); };
    controller.gamepad.dpad.down.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_DOWN, pressed); };
    controller.gamepad.dpad.left.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_LEFT, pressed); };
    controller.gamepad.dpad.right.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) { handleButtonChange(SIOS_RIGHT, pressed); };
    controller.controllerPausedHandler = ^(GCController *controller) {
        handleButtonChange(SIOS_START, YES);
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            handleButtonChange(SIOS_START, NO);
        });
    };
    // No select button
}

- (void)removeHandlers:(GCController *)controller {
    controller.gamepad.buttonA.valueChangedHandler = nil;
    controller.gamepad.buttonB.valueChangedHandler = nil;
    controller.gamepad.buttonX.valueChangedHandler = nil;
    controller.gamepad.buttonY.valueChangedHandler = nil;
    controller.gamepad.leftShoulder.valueChangedHandler = nil;
    controller.gamepad.rightShoulder.valueChangedHandler = nil;
    controller.gamepad.dpad.up.valueChangedHandler = nil;
    controller.gamepad.dpad.down.valueChangedHandler = nil;
    controller.gamepad.dpad.left.valueChangedHandler = nil;
    controller.gamepad.dpad.right.valueChangedHandler = nil;
    controller.controllerPausedHandler = nil;
}

- (void)controllerDidConnect:(NSNotification *)notification {
    [self installHandlers:[notification object]];
}

- (void)controllerDidDisconnect:(NSNotification *)notification {
    [self removeHandlers:[notification object]];
}

@end

void handleButtonChange(long button, BOOL pressed) {
    if (pressed) {
        SISetControllerPushButton(button);
    } else {
        SISetControllerReleaseButton(button);
    }
}
