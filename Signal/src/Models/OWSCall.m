//  Created by Dylan Bourgeois on 20/11/14.
//  Portions Copyright (c) 2016 Open Whisper Systems. All rights reserved.

#import "OWSCall.h"
#import <JSQMessagesViewController/JSQMessagesTimestampFormatter.h>
#import <JSQMessagesViewController/UIImage+JSQMessages.h>

@implementation OWSCall

#pragma mark - Initialzation

- (instancetype)initWithCallerId:(NSString *)senderId
               callerDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                          status:(CallStatus)status
                   displayString:(NSString *)detailString
{
    NSParameterAssert(senderId != nil);
    NSParameterAssert(senderDisplayName != nil);

    self = [super init];
    if (self) {
        _senderId = [senderId copy];
        _senderDisplayName = [senderDisplayName copy];
        _date = [date copy];
        _status = status;
        _messageType = TSCallAdapter;
        _detailString = [detailString stringByAppendingFormat:@" "];
    }
    return self;
}

- (id)init
{
    NSAssert(NO,
        @"%s is not a valid initializer for %@. Use %@ instead",
        __PRETTY_FUNCTION__,
        [self class],
        NSStringFromSelector(@selector(initWithCallerId:callerDisplayName:date:status:displayString:)));
    return nil;
}

- (void)dealloc
{
    _senderId = nil;
    _senderDisplayName = nil;
    _date = nil;
}

- (NSString *)dateText
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    return [dateFormatter stringFromDate:_date];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    OWSCall *aCall = (OWSCall *)object;

    return [self.senderId isEqualToString:aCall.senderId] &&
        [self.senderDisplayName isEqualToString:aCall.senderDisplayName]
        && ([self.date compare:aCall.date] == NSOrderedSame) && self.status == aCall.status;
}

- (NSUInteger)hash
{
    return self.senderId.hash ^ self.date.hash;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@>",
                     [self class],
                     self.senderId,
                     self.senderDisplayName,
                     self.date];
}
#pragma mark - JSQMessageData

// TODO I'm not sure this is right. It affects bubble rendering.
- (BOOL)isMediaMessage
{
    return NO;
}
#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _senderId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(senderId))];
        _senderDisplayName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(senderDisplayName))];
        _date = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(date))];
        _status = (CallStatus)[aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(status))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.senderId forKey:NSStringFromSelector(@selector(senderId))];
    [aCoder encodeObject:self.senderDisplayName forKey:NSStringFromSelector(@selector(senderDisplayName))];
    [aCoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
    [aCoder encodeDouble:self.status forKey:NSStringFromSelector(@selector(status))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithCallerId:self.senderId
                                             callerDisplayName:self.senderDisplayName
                                                          date:self.date
                                                        status:self.status
                                                 displayString:self.detailString];
}

- (NSUInteger)messageHash
{
    return self.hash;
}
- (NSString *)text
{
    return _detailString;
}
@end