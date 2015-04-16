//  PathService.h
//  KuaiKuai
//
//  Created by hxc on 13-4-21.
//  Copyright (c) 2013年 Andy. All rights reserved.
//
//修改记录
//20130421 11:18（易偲）：常用路径及目录服务

#import <Foundation/Foundation.h>

#define MEDIA_TYPE_CACHE_AUDIO @"audios"
#define MEDIA_TYPE_CACHE_IMAGE @"images"
#define MEDIA_TYPE_GENERAL_IMAGE @"images"

//我的文件夹相关
#define FILE_CACHE_DOCUMENT @"mydocuments"
#define FILE_CACHE_TEMP @"temp"

#define FILE_TYPE_CACHE_DOC @"doc"
#define FILE_TYPE_CACHE_PIC @"pic"
#define FILE_TYPE_CACHE_MUSIC @"music"
#define FILE_TYPE_CACHE_VIDEO @"video"
#define FILE_TYPE_CACHE_OTHER @"other"

//全局配置文件
#define ALL_CONFIG_FILE_NAME @"allconfig.plist"
//用户配置文件
#define USER_CONFIG_FILE_NAME @"userconfig.plist"
//用户登录数据文件,存放用于登陆的基本信息
#define USER_DATA_FILE_NAME @"userdata.plist"
//数据库文件
#define USER_DB_FILE_NAME @"userdb.sqlite3"

@interface PathService : NSObject

//取得某个用户的某种资源类型，某个文件的具体路径
+ (NSString *)pathForFile:(NSString *)fileName 
				   userId:(NSInteger )userId 
				mediaType:(NSString *)mediaType;

//取得某个用户的某种资源类型的根目录
+ (NSString *)pathForMediaType:(NSString *)mediaType
						userId:(NSString *)userId;

//取得某个用户id全部资源类型文件的目录
+ (NSString *)pathForUserId:(NSString *)userId;

//取得所有用户、所有资源的根目录
+ (NSString *)pathForAllUsers;

//所有用户caches位置，一般图像、较大的wav音频都存放在这里
+ (NSString *)pathForAllUserCaches;

//取得用户登录信息缓存文件的路径
+ (NSString *)pathForAllUserDataFile;

//取得用户数据库文件的路径
+ (NSString *)pathForUserDataBaseFileOfUser:(NSString *)userId;

//取得全局配置文件路径
+ (NSString *)pathForAllConfigFile;

//取得单个用户配置文件路径
+ (NSString *)pathForConfigFileOfUser:(NSString *)userId;

//将url链接上的文件名转化为本地文件名（不带路径）
+ (NSString *)fileNameForUrlStr:(NSString *)urlStr;

//在一个文件的主文件名后增加一个字符串
+ (NSString *)fileNameByAppending:(NSString *)appendStr inMainOfFileName:(NSString *)fileName;

//登录时检查并初始化用户的路径结构
+ (NSString*)checkAndMakePathsForUser:(NSString *)userId;
//获取聊天对象语音路径
+ (NSString*)CheckAndMakeAudioPathForTarget:(NSString*)userId;

//检查或创建登录用户“我的文件夹“相关目录：如下载和缓存目录
+(void)checkAndMakeMyDocumentPathForUser:(NSString *)userId;
//获取用户我的文件夹下各文件类型目录路径
+ (NSString *)pathForDocumentType:(NSString *)type userId:(NSString *)userId;
//用户下载文件缓存路径
+ (NSString *)pathForMyDownloadTempWithId:(NSString *)userId;
//用户
//+(void)pathForPlistFilePathWithUser:(NSString *)userId groupId:(NSInteger)groupId;
@end
