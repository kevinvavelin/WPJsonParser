//
//  WPJsonParser.h
//  WPJsonParser
//
//  Created by Vavelin Kévin on 07/01/13.
//  Copyright (c) 2013 Vavelin Kévin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WPJsonParser : NSObject <NSURLConnectionDelegate>
{
    AFHTTPClient *httpClient;
}


@property(nonatomic, strong) NSString *urlSite;

// JSON From URL
@property(nonatomic, strong) NSDictionary *json;

// Array of post from json
@property(nonatomic, strong) NSArray *post;

@property(nonatomic, strong) NSMutableArray *postFromID;

// Array of category
@property(nonatomic, strong) NSMutableArray *category;

// Content of post
@property(nonatomic, strong) NSMutableArray *contentOfPost;

// Id of category
@property(nonatomic, strong) NSMutableArray *categoryID;

// Post in category
@property(nonatomic, strong) NSArray *categoryPosts;

@property(nonatomic, strong) NSArray *categoryTitlePost; // Titre
@property(nonatomic, strong) NSArray *categoryInfoPost;  // Description
@property(nonatomic, strong) NSArray *categoryCommCountPost; // Nb comm
@property(nonatomic, strong) NSArray *categoryImagePost; // Image

// Property of post
@property(nonatomic, strong) NSDictionary *article;

@property(nonatomic, strong) NSMutableArray *titleArray;

@property(nonatomic, strong) NSMutableArray *imageArray;

// Initial URL of wordpress
@property(nonatomic, strong) NSString *url;

// URL Image for thumbnail
@property(nonatomic, strong) NSString *urlImage;

//URL Video Dailymotion
@property(nonatomic, strong) NSString *urlVideo;

// Author of post
@property(nonatomic, strong) NSString *authorPost;

@property (nonatomic, strong) NSString *infoPost;

// Title of post
@property(nonatomic, strong) NSString *titlePost;

// Id of post
@property(nonatomic, strong) NSMutableArray *postID;

// Array of comment
@property(nonatomic, strong) NSMutableArray *commentArray;

@property(nonatomic, strong) NSMutableArray *authorOfComment;

@property (nonatomic, strong) NSString *commPost;

// Article description
@property(nonatomic, strong) NSString *descriptionArticle;

@property(nonatomic, strong) NSMutableArray *infoArray;

@property(nonatomic, strong) NSArray *arrayCount;


// parameters for comment post

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *mail;
@property(nonatomic, strong) NSString *content;
@property(nonatomic) NSString *postCommentReturn;

@property(nonatomic, strong) NSDictionary *categoryDic;

-(id)initWithCommand:(NSString *)command ofURL:(NSString *)url;
-(id)initWithURL:(NSString *)url;

-(NSArray *)getRecentPostOfURL:(NSString *)url withCount:(NSInteger)count;
-(NSMutableArray *)getCategoryOfURL:(NSString *)url;
-(NSArray *)getPostOfCategory:(NSString *)idCategory;
-(NSArray *)getPostWithId:(NSArray *)arrayOfId;
- (NSArray*)getInfoPost:(NSArray*)post;
-(NSMutableArray *)getPostContent;
-(NSMutableArray *)getID;
-(NSDictionary *)getPost:(NSArray *)arrayOfPost atIndex:(NSInteger)index;


-(NSString *)getURLImageThumbnailOfPost:(NSInteger)idArticle;
-(NSArray *)getImage:(NSArray *)post;
-(UIImage *)getImageOfPost:(NSDictionary *)post;

-(NSString *)getURLPost;
-(NSString *)getAuthorOfPost;
-(NSArray *)getTitlePost:(NSArray *)post;
-(NSArray *)getTitleOfPost:(NSArray *)post;
-(NSArray *)getDescription;
-(NSArray *)getDescriptionOfPost:(NSArray *)post;

-(NSArray *)getCommentOfPost:(NSDictionary *)post;
- (NSArray*)getCommPost:(NSArray*)post;

-(NSArray *)getArrayCountPost:(NSArray *)post;

-(void)postCommentOnArticle:(NSString *)articleID withName:(NSString *)author mail:(NSString *)email content:(NSString *)content host:(NSString *)url;

@end
