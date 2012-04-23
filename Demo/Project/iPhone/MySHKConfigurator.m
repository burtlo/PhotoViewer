//
//  MySHKConfigurator.m
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/23/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "MySHKConfigurator.h"

@implementation MySHKConfigurator

+ (void)setup {
    
    static BOOL configurationHasNotBeenDone = YES;
    
    if (configurationHasNotBeenDone) {
        DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
        [SHKConfiguration sharedInstanceWithConfigurator:configurator];
        
        configurationHasNotBeenDone = NO;
    }

}



@end
