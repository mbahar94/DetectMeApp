//
//  AnnotatedImage+Create.h
//  DetectMe
//
//  Created by Josep Marc Mingot Hidalgo on 11/10/13.
//  Copyright (c) 2013 Josep Marc Mingot Hidalgo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <coreMotion/CoreMotion.h>
#import "AnnotatedImage.h"
#import "Detector.h"
#import "Box.h"

@interface AnnotatedImage (Create)


+ (AnnotatedImage *) annotatedImageWithImage:(UIImage *)image
                                         box:(Box *)box
                                 forLocation:(CLLocation *) location
                                   forMotion:(CMDeviceMotion *) motion
                                     forUser:(User *)currentUser
                      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (AnnotatedImage *) annotatedImageWithDictionaryInfo:(NSDictionary *)annotatedImageInfo
                               inManagedObjectContext:(NSManagedObjectContext *)context
                                          forDetector:(Detector *)detector;

- (Box *) boxForAnnotatedImage;
- (void) setBox:(Box *) box;

@end
