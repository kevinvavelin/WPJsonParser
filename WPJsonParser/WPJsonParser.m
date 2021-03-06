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

// Init With Command

-(id)initWithCommand:(NSString *)command ofURL:(NSString *)url
{
    self.url = [NSString stringWithFormat:@"http://%@/api/%@/", url, command];
    self.urlSite = url;
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url] options:NSUTF8StringEncoding error:nil] options:NSJSONReadingAllowFragments error:nil];
    self.contentOfPost = [NSMutableArray array];
    if([command isEqualToString:kJSONParserCommandCategory])
    {
        [self getCategoryOfURL:url];
    }
    if([command isEqualToString:kJSONParserCommandRecentPost
        ])
    {
        self.post = [self.json objectForKey:@"posts"];
    }
    return self;
}

-(id)initWithURL:(NSString *)url
{
    self.urlSite = url;
    [self getCategoryOfURL:url];
    return self;
}

//#pragma mark NSURLConnection Delegate
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSString *message = [NSString stringWithFormat:@"Le serveur ne répond pas. Erreur %@", error];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connexion impossible" message:message delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil, nil];
//    [alert show];
//}

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
    self.urlSite = url;
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
    self.categoryDic = [[NSDictionary alloc] initWithObjects:self.categoryID forKeys:self.category];
    return self.category;
}

// Get all post from category, you have to get ID Category for this

-(NSArray *)getPostOfCategory:(NSString *)idCategory
{
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get_category_posts/?id=%@", self.urlSite, idCategory]]] options:NSJSONReadingAllowFragments error:nil];
    self.categoryPosts = [self.json objectForKey:@"posts"];
    self.categoryTitlePost = [self getTitleOfPost:self.categoryPosts];
    self.categoryImagePost = [self getImage:self.categoryPosts];
    self.categoryInfoPost = [self getInfoPost:self.categoryPosts];
    self.categoryCommCountPost = [self getCommPost:self.categoryPosts];
    return self.categoryPosts;
}


-(NSArray *)getPostWithId:(NSArray *)arrayOfId
{
    self.postFromID = [NSMutableArray array];
    for(int i = 0; i < [arrayOfId count]; i++)
    {
        self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/get_post/?id=%@", self.urlSite, [arrayOfId objectAtIndex:i]]]] options:NSJSONReadingAllowFragments error:nil];
        self.post = [self.json objectForKey:@"post"];
        [self.postFromID addObject:self.post];
    }
    return self.postFromID;
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

- (NSArray*)getArrayCountPost:(NSArray *)post
{
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.spi0n.com/api/%@", kJSONParserCommandGetIndex]]] options:0 error:nil];
    NSArray *categoryInfos = [self.json objectForKey:@"categories"];
    NSMutableArray *countMut = [[NSMutableArray alloc] init];
    for(int i = 0; i < [categoryInfos count]; i++)
    {
    NSDictionary *idCategory = [categoryInfos objectAtIndex:i];
    [countMut addObject:[idCategory objectForKey:@"post_count"]];
    }
    self.arrayCount = countMut;
    return self.arrayCount;
}

-(NSArray *)getImage:(NSArray *)post
{
    [self.imageArray removeAllObjects];
    self.imageArray = [NSMutableArray array];
    for(int i = 0; i < [post count]; i++)
    {
        NSDictionary *postOfImage = [post objectAtIndex:i];
        self.urlImage = [postOfImage objectForKey:@"thumbnail"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlImage]]];
        if(image != nil)
        {
            [self.imageArray addObject:image];
        }
        else {
            UIImage *imageEmpty = [UIImage imageNamed:@"home"];
            [self.imageArray addObject:imageEmpty];
        }
    }
    return self.imageArray;
}

-(UIImage *)getImageOfPost:(NSDictionary *)post
{
    NSString *url = [post objectForKey:@"thumbnail"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return image;
}

// If your article contain some video, this method will get it

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

// Return the author

-(NSString *)getAuthorOfPost
{
    NSDictionary *postInfo = [self.article objectForKey:@"author"];
    self.authorPost = [postInfo objectForKey:@"nickname"];
    return self.authorPost;
}

// Return title of post

-(NSArray *)getTitlePost:(NSArray *)post
{
    [self.titleArray removeAllObjects];
    self.titleArray = [NSMutableArray array];
    for(int i = 0; i < [self.post count]; i++)
    {
        self.article = [self.post objectAtIndex:i];
        NSString *titre = [self.article objectForKey:@"title"];
        self.titlePost = [titre stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
        [self.titleArray addObject:self.titlePost];
    }
    return self.titleArray;
}

-(NSArray *)getTitleOfPost:(NSArray *)post
{
    [self.titleArray removeAllObjects];
    self.titleArray = [NSMutableArray array];
    for(int i= 0; i < [post count]; i++)
    {
        self.article = [post objectAtIndex:i];
        NSString *titre = [self.article objectForKey:@"title"];
        self.titlePost = [titre stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
        [self.titleArray addObject:self.titlePost];
    }
    return self.titleArray;
}

// Return description

-(NSArray *)getDescription
{
    NSMutableArray *arrayOfDescription = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.post count]; i++)
    {
        self.article = [self.post objectAtIndex:i];
        self.descriptionArticle = [self.article objectForKey:@"excerpt"];
        NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
        self.descriptionArticle = [regex stringByReplacingMatchesInString:self.descriptionArticle options:0 range:NSMakeRange(0, [self.descriptionArticle length]) withTemplate:@"$2"];
        NSString *textWithoutStrong = [self.descriptionArticle stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        NSString *textWithoutStrongEnd = [textWithoutStrong stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
        self.descriptionArticle = textWithoutStrongEnd;
        [arrayOfDescription addObject:self.descriptionArticle];
    }
    return arrayOfDescription;
}

-(NSArray *)getDescriptionOfPost:(NSArray *)post
{
    NSMutableArray *arrayOfDescription = [NSMutableArray array];
    for(int i = 0; i < [post count]; i++)
    {
        self.article = [post objectAtIndex:i];
        self.descriptionArticle = [self.article objectForKey:@"excerpt"];
        NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
        self.descriptionArticle = [regex stringByReplacingMatchesInString:self.descriptionArticle options:0 range:NSMakeRange(0, [self.descriptionArticle length]) withTemplate:@"$2"];
        NSString *textWithoutStrong = [self.descriptionArticle stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        NSString *textWithoutStrongEnd = [textWithoutStrong stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
        self.descriptionArticle = textWithoutStrongEnd;
        [arrayOfDescription addObject:self.descriptionArticle];
    }
    return arrayOfDescription;

}

- (NSArray*)getInfoPost:(NSArray*)post
{
    _infoArray = [NSMutableArray array];
    for (int i = 0; i < [post count]; i++)
    {
        self.article = [post objectAtIndex:i];
        NSString *author = [[self.article objectForKey:@"author"] objectForKey:@"nickname"];
        NSString *date = [self.article objectForKey:@"modified"];
        self.infoPost = [NSString stringWithFormat:@"Par %@ le %@", author, date];
        
        [_infoArray addObject:self.infoPost];
    }
    
    return _infoArray;
}

- (NSArray*)getCommPost:(NSArray*)post
{
    NSMutableArray *commArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [post count]; i++)
    {
        self.article = [post objectAtIndex:i];
        self.commPost = [[self.article objectForKey:@"comment_count"] stringValue];
        
        [commArray addObject:self.commPost];
    }
    
    return commArray;
}

// Get comment

-(NSArray *)getCommentOfPost:(NSDictionary *)post
{
    self.commentArray = [NSMutableArray array];
    self.authorOfComment = [NSMutableArray array];
    NSArray *arrayOfComments = [post valueForKey:@"comments"];
    for(int i = 0; i < [arrayOfComments count]; i++)
    {
        NSDictionary *textComment = [arrayOfComments objectAtIndex:i];
        NSString *beginCommentaire = [textComment valueForKey:@"content"];
        NSString *name = [textComment valueForKey:@"name"];
        NSString *removeBalise = [beginCommentaire stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        NSString *removeEndBalise = [removeBalise stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        NSString *commentaire = [removeEndBalise stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
        [self.commentArray addObject:commentaire];
        [self.authorOfComment addObject:name];
    }
    return self.commentArray;
}

// TO DO 

-(void)postCommentOnArticle:(NSString *)articleID withName:(NSString *)author mail:(NSString *)email content:(NSString *)content host:(NSString *)url
{
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]];
    NSDictionary *parameters = @{@"post_id": articleID,
                                 @"name" : author,
                                 @"email" : email,
                                 @"content" : content
                                 };
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlRequest];
    [httpClient postPath:@"/api/submit_comment/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.postCommentReturn = [response valueForKey:@"status"];
            if([self.postCommentReturn isEqualToString:@"error"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    }failure:nil];
}

@end
