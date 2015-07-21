//
//  RPSyntaxMatcher.m
//  RPSyntaxHighlighter
//
//  Created by Rhys Powell on 19/01/13.
//  Copyright (c) 2013 Rhys Powell. All rights reserved.
//

#import "RPSyntaxMatcher.h"
#import "RPScopedMatch.h"

@implementation RPSyntaxMatcher

//+ (NSArray *)matchersWithFile:(NSString *)filename
//{
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
//    
//    NSError *error = nil;
//    id matcherArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//    if (error) {
//        NSLog(@"[RPSyntaxHighlighter] Error loading matcher JSON: %@", error.localizedDescription);
//    }
//    
//    NSMutableArray *matchers = [[NSMutableArray alloc] init];
//    for (NSDictionary *matcherDict in (NSArray *)matcherArray) {
//        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
//        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:matcherDict[@"pattern"] options:0 error:nil];
//        matcher.scopes = matcherDict[@"scopes"];
//        [matchers addObject:matcher];
//    }
//    
//    return matchers;
//}

+ (NSArray *)matchersWithFile:(NSString *)filename
{
    if (!filename) {
        return @[];
    }
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *syntaxDefinition = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    if (!filepath) {
        NSLog(@"[RPSyntaxHighlighter] Error loading syntax definition: %@", filename);
        return @[];
    }
    
    NSMutableArray *matchers = [[NSMutableArray alloc] init];
    NSString *pattern;

//    </?\w+\s+[^>]*>
    NSString *beginCommand = syntaxDefinition[@"beginCommand"], *endCommand = syntaxDefinition[@"endCommand"];
    if (beginCommand.length && endCommand.length) {
        pattern = [NSString stringWithFormat:@"(%@/?\\w+[^%@]*%@)", beginCommand, endCommand, endCommand];
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matcher.scopes = @[@"function"];
        [matchers addObject:matcher];
    }
    
    NSString *firstString = syntaxDefinition[@"firstString"];
    if (firstString.length) {
        NSString *secondString = syntaxDefinition[@"secondString"];
        if (secondString && secondString.length) {
            pattern = [NSString stringWithFormat:@"(%@[^%@|\\n]*%@|%@[^%@|\\n]*%@)(?m)", firstString, firstString, firstString, secondString, secondString, secondString];
        } else {
            pattern = [NSString stringWithFormat:@"(%@[^%@|\\n]*%@)(?m)", firstString, firstString, firstString];
        }
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matcher.scopes = @[@"string"];
        [matchers addObject:matcher];
    }
    
    NSString *firstSingleLineComment = syntaxDefinition[@"firstSingleLineComment"];
    if (firstSingleLineComment.length) {
        NSString *secondSingleLineComment = syntaxDefinition[@"secondSingleLineComment"];
        if (secondSingleLineComment && secondSingleLineComment.length) {
            pattern = [NSString stringWithFormat:@"(?im)(%@|%@)[\\s\\S]*?$", firstSingleLineComment, secondSingleLineComment];
        } else {
            pattern = [NSString stringWithFormat:@"(?im)(%@)[\\s\\S]*?$", firstSingleLineComment];
        }
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matcher.scopes = @[@"comment"];
        [matchers addObject:matcher];
    }
    
    NSString *beginFirstMultiLineComment = syntaxDefinition[@"beginFirstMultiLineComment"];
    NSString *endFirstMultiLineComment = syntaxDefinition[@"endFirstMultiLineComment"];
    if (beginFirstMultiLineComment.length && endFirstMultiLineComment.length) {
        pattern = [NSString stringWithFormat:@"(?im)%@[\\s\\S]*?%@$", beginFirstMultiLineComment, endFirstMultiLineComment];
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matcher.scopes = @[@"comment"];
        [matchers addObject:matcher];
    }
    
    NSString *beginSecondMultiLineComment = syntaxDefinition[@"beginSecondMultiLineComment"];
    NSString *endSecondMultiLineComment = syntaxDefinition[@"endSecondMultiLineComment"];
    if (beginSecondMultiLineComment.length && endSecondMultiLineComment.length) {
        pattern = [NSString stringWithFormat:@"(?im)%@[\\s\\S]*?%@$", beginSecondMultiLineComment, endSecondMultiLineComment];
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matcher.scopes = @[@"comment"];
        [matchers addObject:matcher];
    }
    
    BOOL caseSensitive = [syntaxDefinition[@"keywordsCaseSensitive"] boolValue];
    NSArray *keywords = syntaxDefinition[@"keywords"];
    if (keywords && keywords.count) {
        NSMutableString *pattern = [[NSMutableString alloc] initWithString:@"\\b("];
        for (int i = 0; i < keywords.count; i++) {
            NSString *k = keywords[i];
            if (i == keywords.count - 1) {
                [pattern appendFormat:@"%@)\\b", k];
            } else {
                [pattern appendFormat:@"%@|", k];
            }
        }
        RPSyntaxMatcher *matcher = [[RPSyntaxMatcher alloc] init];
        matcher.pattern = [NSRegularExpression regularExpressionWithPattern:pattern options:caseSensitive ? NSRegularExpressionCaseInsensitive : 0 error:nil];
        matcher.scopes = @[@"keyword"];
        [matchers addObject:matcher];
    }
    return matchers;
}

- (NSSet *)matchesInString:(NSString *)string
{
    NSMutableSet *matches = [[NSMutableSet alloc] init];
    
    [self.pattern enumerateMatchesInString:string options:0 range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        RPScopedMatch *match = [[RPScopedMatch alloc] init];
        match.scopes = self.scopes;
        match.range = [result range];
        [matches addObject:match];
    }];
    
    return [NSSet setWithSet:matches];
}

@end
