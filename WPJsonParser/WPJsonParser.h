//
//  WPJsonParser.h
//  WPJsonParser
//
//  Created by Vavelin Kévin on 07/01/13.
//  Copyright (c) 2013 Vavelin Kévin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPJsonParser : NSObject


@property(nonatomic, retain) NSString *urlSite;

// JSON From URL
@property(nonatomic, retain) NSDictionary *json;

// Array of post from json
@property(nonatomic, retain) NSArray *post;

// Array of category
@property(nonatomic, retain) NSMutableArray *category;

// Content of post
@property(nonatomic, retain) NSMutableArray *contentOfPost;

// Id of category
@property(nonatomic, retain) NSMutableArray *categoryID;

// Post in category
@property(nonatomic, retain) NSArray *categoryPosts;

// Property of post
@property(nonatomic, retain) NSDictionary *article;

// Initial URL of wordpress
@property(nonatomic, retain) NSString *url;

// URL Image for thumbnail
@property(nonatomic, retain) NSString *urlImage;

//URL Video Dailymotion
@property(nonatomic, retain) NSString *urlVideo;

// Author of post
@property(nonatomic, retain) NSString *authorPost;


// Title of post
@property(nonatomic, retain) NSString *titlePost;

// Id of post
@property(nonatomic, retain) NSMutableArray *postID;

// Array of comment
@property(nonatomic, retain) NSArray *commentArray;

// Article description
@property(nonatomic, retain) NSString *descriptionArticle;


// parameters for comment post

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *mail;
@property(nonatomic, retain) NSString *content;

-(id)initWithCommand:(NSString *)command ofURL:(NSString *)url;

-(NSArray *)getRecentPostOfURL:(NSString *)url withCount:(NSInteger)count;
-(NSMutableArray *)getCategoryOfURL:(NSString *)url;
-(NSMutableArray *)getPostContent;
-(NSMutableArray *)getID;
-(NSDictionary *)getPost:(NSArray *)arrayOfPost atIndex:(NSInteger)index;


-(NSString *)getURLImageThumbnailOfPost:(NSInteger)idArticle;

-(NSString *)getURLPost;
-(NSString *)getContentOfPost:(NSInteger)index;
-(NSString *)getAuthorOfPost;
-(NSString *)getTitlePost;
-(NSArray *)getDescription;

-(NSArray *)getCommentOfPost;

@end
