//
//  WPJsonParser.m
//  WPJsonParser
//
//  Created by Vavelin Kévin on 07/01/13.
//  Copyright (c) 2013 Vavelin Kévin. All rights reserved.
//

#import "WPJsonParser.h"

#define kJSONParserCommandCategory @"get_category_index"
#define kJSONParserCommandRecentPost @"get_recent_posts"
#define kJSONParserCommandGetIndex @"get_category_index"
#define kJSONParserCommandGetPost @"get_post"
#define kJSONParserCommandGetPage @"get_page"
#define kJSONParserCommandGetDatePost @"get_date_posts"
#define kJSONParserCommandGetCategoryPost @"get_category_posts"
#define kJSONParserCommandGetTagPosts @"get_tag_posts"
#define kJSONParserCommandGetAuthorPosts @"get_author_posts"
#define kJSONParserCommandGetSearchResult @"get_search_results"
#define kJSONParserCommandGetDateIndex @"get_date_index"
#define kJSONParserCommandGetTagIndex @"get_tag_index"
#define kJSONParserCommandGetAuthorIndex @"get_author_index"
#define kJSONParserCommandGetPageIndex @"get_page_index"

@implementation WPJsonParser

@synthesize url = _url;
@synthesize json = _json;
@synthesize post = _post;
@synthesize article = _article;
@synthesize urlImage = _urlImage;
@synthesize urlVideo = _urlVideo;
@synthesize postID = _postID;

// Init With Command

-(id)initWithCommand:(NSString *)command ofURL:(NSString *)url
{
    self.url = [NSString stringWithFormat:@"http://%@/api/%@/", url, command];
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]] options:NSJSONReadingAllowFragments error:nil];
    self.contentOfPost = [NSMutableArray array];
    if([command isEqualToString:kJSONParserCommandCategory])
    {
        [self getCategoryOfURL:url];
    }
    if([command isEqualToString:kJSONParserCommandRecentPost
        ])
    {
        self.post = [self.json objectForKey:@"posts"];
        self.article = [self.post objectAtIndex:0];
    }
    return self;

}

// Return an array with recent post of your URL

-(NSArray *)getRecentPostOfURL:(NSString *)url withCount:(NSInteger)count
{
    self.urlSite = url;
    self.url = [NSString stringWithFormat:@"http://%@/api/get_recent_posts/?count=%i", url, count];
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]] options:NSJSONReadingAllowFragments error:nil];
    self.post = [self.json objectForKey:@"posts"];
    return self.post;
}

// Return all category from your URL

-(NSMutableArray *)getCategoryOfURL:(NSString *)url
{
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/%@",url, kJSONParserCommandGetIndex]]] options:0 error:nil];
    NSArray *categoryInfos = [self.json objectForKey:@"categories"];
    self.category = [[NSMutableArray alloc] init];
    self.categoryID = [[NSMutableArray alloc] init];
    for(int i = 0; i < [categoryInfos count]; i++)
    {
        NSDictionary *title = [categoryInfos objectAtIndex:i];
        NSDictionary *idCategory = [categoryInfos objectAtIndex:i];
        NSString *idCategoryString = [idCategory objectForKey:@"id"];
        NSData *changeEncoding = [[title objectForKey:@"title"] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *titleCategoryString = [[NSString alloc] initWithData:changeEncoding encoding:NSUTF8StringEncoding];
        NSString *finalString = [titleCategoryString stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
        [self.category addObject:finalString];
        [self.categoryID addObject:idCategoryString];
    }
    return self.category;
}

// Get all post from category, you have to get ID Category for this

-(NSArray *)getPostOfCategory:(NSInteger)idCategory
{
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get_category_posts/?id=%i", self.urlSite, idCategory]]] options:NSJSONReadingAllowFragments error:nil];
    self.categoryPosts = [self.json objectForKey:@"posts"];
    return self.categoryPosts;
}

// Return an array of post ID

-(NSMutableArray *)getID
{
    for (int i = 0; i < [self.post count]; i++)
    {
        NSDictionary *post = [self.post objectAtIndex:i];
        [self.postID addObject:[post objectForKey:@"id"]];
    }
    return self.postID;
}

// Get your post

-(NSDictionary *)getPost:(NSArray *)arrayOfPost atIndex:(NSInteger)index
{
    self.article = [arrayOfPost objectAtIndex:index];
    return self.article;
}

// Get image Thumbnail in 110x110

-(NSString *)getURLImageThumbnailOfPost:(NSInteger)idArticle
{
    NSDictionary *postOfImage = [self.post objectAtIndex:idArticle];
    NSArray *attachments = [postOfImage objectForKey:@"attachments"];
    NSDictionary *contentOfAttachments = [attachments objectAtIndex:0];
    NSDictionary *sizeImage = [contentOfAttachments objectForKey:@"images"];
    NSDictionary *imageInfos = [sizeImage objectForKey:@"thumbnail"];
    self.urlImage = [imageInfos objectForKey:@"url"];
    return self.urlImage;
}

-(NSString *)getURLVideoArticle:(NSInteger)idArticle
{
    NSDictionary *postOfVideo = [self.post objectAtIndex:idArticle];
    NSString *content = [postOfVideo objectForKey:@"content"];
    NSRange rangeOfURL = [content rangeOfString:@"href=\"http://www.dailymotion.com/"];
    NSString *beginURL = [content substringFromIndex:rangeOfURL.location];
    NSRange deleteHREF = [beginURL rangeOfString:@"http"];
    NSString *url = [beginURL substringFromIndex:deleteHREF.location];
    NSRange endURL = [url rangeOfString:@"\""];
    self.urlVideo = [beginURL substringToIndex:endURL.location];
    return self.urlVideo;
}

// Return URL of your post

-(NSString *)getURLPost
{
   return [self.article objectForKey:@"url"];
}

// Return all HTML of post

-(NSMutableArray *)getPostContent
{
    for(int i = 0; i < [self.article count]; i++)
    {
       NSDictionary *post = [self getPost:self.post atIndex:i];
        NSString *content = [post objectForKey:@"content"];
        [self.contentOfPost addObject:content];
    }
    return self.contentOfPost;
}

// Return the content of your post

-(NSString *)getContentOfPost:(NSInteger)index
{
    [self getPostContent];
    NSString *content = [self.contentOfPost objectAtIndex:index];
    return content;
}

// Return the author

-(NSString *)getAuthorOfPost
{
    NSDictionary *postInfo = [self.article objectForKey:@"author"];
    self.authorPost = [postInfo objectForKey:@"nickname"];
    return self.authorPost;
}

// Return title of post

-(NSString *)getTitlePost
{
    self.authorPost = [self.article objectForKey:@"title"];
    return self.authorPost;
}

// Return description

-(NSString *)getDescription
{
    self.descriptionArticle = [self.article objectForKey:@"excerpt"];
    NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    self.descriptionArticle = [regex stringByReplacingMatchesInString:self.descriptionArticle options:0 range:NSMakeRange(0, [self.descriptionArticle length]) withTemplate:@"$2"];
    NSString *textWithoutStrong = [self.descriptionArticle stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    NSString *textWithoutStrongEnd = [textWithoutStrong stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    self.descriptionArticle = textWithoutStrongEnd;
    return self.descriptionArticle;
}

// Get comment

-(NSArray *)getCommentOfPost
{
    self.commentArray = [self.article objectForKey:@"comments"];
    return self.commentArray;
}

// TO DO 

-(void)postCommentWithName:(NSString *)author mail:(NSString *)email content:(NSString *)content host:(NSString *)url id:(NSInteger)index
{
    NSInteger idPost = [[self.postID objectAtIndex:index] integerValue];
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/submit_comment?post_id=%i?name=%@?email=%@,content=%@", url, idPost, author, email, content]];
    NSURLRequest *postComment = [NSURLRequest requestWithURL:urlString];
    NSURLConnection *connect = [NSURLConnection connectionWithRequest:postComment delegate:self];
}

@end
