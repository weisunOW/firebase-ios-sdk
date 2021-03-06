/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FIRGeoPoint+Internal.h"

#import "FSTComparison.h"
#import "FSTUsageValidation.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FIRGeoPoint

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude {
  if (self = [super init]) {
    if (latitude < -90 || latitude > 90 || !isfinite(latitude)) {
      FSTThrowInvalidArgument(
          @"GeoPoint requires a latitude value in the range of [-90, 90], "
           "but was %f",
          latitude);
    }
    if (longitude < -180 || longitude > 180 || !isfinite(longitude)) {
      FSTThrowInvalidArgument(
          @"GeoPoint requires a longitude value in the range of [-180, 180], "
           "but was %f",
          longitude);
    }

    _latitude = latitude;
    _longitude = longitude;
  }
  return self;
}

- (NSComparisonResult)compare:(FIRGeoPoint *)other {
  NSComparisonResult result = FSTCompareDoubles(self.latitude, other.latitude);
  if (result != NSOrderedSame) {
    return result;
  } else {
    return FSTCompareDoubles(self.longitude, other.longitude);
  }
}

#pragma mark - NSObject methods

- (NSString *)description {
  return [NSString stringWithFormat:@"<FIRGeoPoint: (%f, %f)>", self.latitude, self.longitude];
}

- (BOOL)isEqual:(id)other {
  if (self == other) {
    return YES;
  }
  if (![other isKindOfClass:[FIRGeoPoint class]]) {
    return NO;
  }
  FIRGeoPoint *otherGeoPoint = (FIRGeoPoint *)other;
  return FSTDoubleBitwiseEquals(self.latitude, otherGeoPoint.latitude) &&
         FSTDoubleBitwiseEquals(self.longitude, otherGeoPoint.longitude);
}

- (NSUInteger)hash {
  return 31 * FSTDoubleBitwiseHash(self.latitude) + FSTDoubleBitwiseHash(self.longitude);
}

/** Implements NSCopying without actually copying because geopoints are immutable. */
- (id)copyWithZone:(NSZone *_Nullable)zone {
  return self;
}

@end

NS_ASSUME_NONNULL_END
