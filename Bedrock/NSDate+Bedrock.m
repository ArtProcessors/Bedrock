//
//  NSDate+Bedrock.m
//  Bedrock
//
//  Created by Nick Forge on 23/05/2016.
//  Copyright © 2016 Nick Forge. All rights reserved.
//

#import "NSDate+Bedrock.h"

NSTimeInterval NSTimeIntervalWithMilliseconds(double milliseconds)
{
	return milliseconds / 1000.0;
}

NSTimeInterval NSTimeIntervalWithMinutes(double minutes)
{
	return minutes * 60.0;
}

NSTimeInterval NSTimeIntervalWithHours(double hours)
{
	return hours * 60.0 * 60.0;
}

NSTimeInterval NSTimeIntervalWithDays(double days)
{
	return days * 24.0 * 60.0 * 60.0;
}

NSString * NSStringFromNSTimeInterval(NSTimeInterval timeInterval, NSTimeIntervalUnit units)
{
	NSMutableArray<NSString *> *colonJoinedComponents = [NSMutableArray new];
	NSMutableArray<NSString *> *spaceJoinedComponents = [NSMutableArray new];
	BOOL hasAddedFirstComponent = NO;
	BOOL isNegative = timeInterval < 0.0;
	if (isNegative) {
		timeInterval = -timeInterval;
	}
	if (units & NSTimeIntervalUnitHour) {
		int hours = (int)floor(timeInterval / (60.0 * 60.0));
		timeInterval -= hours * (60 * 60);
		if (hours < 10 && hasAddedFirstComponent == NO) {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%d", hours]];
		} else {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%02d", hours]];
		}
		hasAddedFirstComponent = YES;
	}
	if (units & NSTimeIntervalUnitMinute) {
		int minutes = (int)floor(timeInterval / 60.0);
		timeInterval -= minutes * (60);
		if (minutes < 10 && hasAddedFirstComponent == NO) {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%d", minutes]];
		} else {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%02d", minutes]];
		}
		hasAddedFirstComponent = YES;
	}
	if (units & NSTimeIntervalUnitSecond) {
		int seconds = (int)floor(timeInterval);
		timeInterval -= seconds;
		if (seconds < 10 && hasAddedFirstComponent == NO) {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%d", seconds]];
		} else {
			[colonJoinedComponents addObject:[NSString stringWithFormat:@"%02d", seconds]];
		}
		hasAddedFirstComponent = YES;
	}
	if (units & NSTimeIntervalUnitMillisecond) {
		int milliseconds = (int)floor(timeInterval * 1000.0);
		timeInterval -= milliseconds;
		[spaceJoinedComponents addObject:[NSString stringWithFormat:@"%03d", milliseconds]];
	}
	NSMutableString *string = [NSMutableString new];
	if (isNegative) {
		[string appendString:@"-"];
	}
	if (colonJoinedComponents.count > 0) {
		[string appendString:[colonJoinedComponents componentsJoinedByString:@":"]];
	}
	if (colonJoinedComponents.count > 0 && spaceJoinedComponents.count > 0) {
		[string appendString:@":"];
	}
	if (spaceJoinedComponents.count > 0) {
		[string appendString:[spaceJoinedComponents componentsJoinedByString:@" "]];
	}
	return string.copy;
}

@implementation NSDate (Bedrock)

// Returns the time interval from <date> until <now>
+ (NSTimeInterval)br_timeIntervalSinceDate:(NSDate *)date
{
	return -date.timeIntervalSinceNow;
}

// Returns the time interval from <now> until <date>
+ (NSTimeInterval)br_timeIntervalUntilDate:(NSDate *)date
{
	return date.timeIntervalSinceNow;
}

// Returns the time interval from <self> until <now>
- (NSTimeInterval)br_timeIntervalUntilNow
{
	return -self.timeIntervalSinceNow;
}

// Returns the time interval from <self> until <date>
- (NSTimeInterval)br_timeIntervalUntilDate:(NSDate *)date
{
	return [date timeIntervalSinceDate:self];
}

- (BOOL)br_isEarlierThanDate:(NSDate *)date
{
	return [self compare:date] == NSOrderedAscending;
}

- (BOOL)br_isLaterThanDate:(NSDate *)date
{
	return [self compare:date] == NSOrderedDescending;
}

@end
