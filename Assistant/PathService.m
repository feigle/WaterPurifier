//  PathService.m
//  KuaiKuai
//
//  Created by hxc on 13-4-21.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

//#import "Globals.h"
#import "PathService.h"

@implementation PathService

+ (NSString *)pathForFile:(NSString *)fileName 
				   userId:(NSInteger )userId 
				mediaType:(NSString *)mediaType {
	if (!userId) {
		userId = 0;
	}
	if (!fileName) {
		fileName = @"";
	}
	if (!mediaType || [mediaType isEqualToString:@""]) {
		mediaType = MEDIA_TYPE_GENERAL_IMAGE;
	}
	NSArray *paths = nil;
	BOOL isInCachesDirectory = ([mediaType rangeOfString:@"cache"].location != NSNotFound);
	if (isInCachesDirectory) {
		paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
	} else {
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	}
	NSString *usersRootDirectory = [paths objectAtIndex:0];
	NSString *filePath1 = nil;
	if (isInCachesDirectory) {
		//caches目录下的资源全部不带用户id，所有用户的缓存文件都存在同一个目录中
		filePath1 = usersRootDirectory;
	} else {
		filePath1 = [usersRootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",userId]];
	}
	NSString *filePath2 = [filePath1 stringByAppendingPathComponent:mediaType];
	NSString *filePath3 = [filePath2 stringByAppendingPathComponent:fileName];
	return filePath3;
}

+ (NSString *)pathForMediaType:(NSString *)mediaType userId:(NSString *)userId {
	if (!mediaType || [mediaType isEqualToString:@""]) {
		mediaType = MEDIA_TYPE_GENERAL_IMAGE;
	}
	NSArray *paths = nil;
	BOOL isInCachesDirectory = ([mediaType rangeOfString:@"cache"].location != NSNotFound);
	if (isInCachesDirectory) {
		paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
	} else {
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	}
	NSString *usersRootDirectory = [paths objectAtIndex:0];
	NSString *filePath1 = nil;
	if (isInCachesDirectory) {
		//caches目录下的资源全部不带用户id，所有用户的缓存文件都存在同一个目录中
		filePath1 = usersRootDirectory;
	} else {
		filePath1 = [usersRootDirectory stringByAppendingPathComponent:userId];
	}
	NSString *filePath2 = [filePath1 stringByAppendingPathComponent:mediaType];
	return filePath1;
}

+ (NSString *)pathForUserId:(NSString *)userId {
	if (!userId || [userId isEqualToString:@""]) {
		userId = @"0";
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:userId];
}

+ (NSString *)pathForAllUsers {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)pathForAllUserCaches {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)pathForAllUserDataFile {
	return [[self pathForAllUsers] stringByAppendingPathComponent:USER_DATA_FILE_NAME];
}

+ (NSString *)pathForUserDataBaseFileOfUser:(NSString *)userId {
	return [[self pathForUserId:userId] stringByAppendingPathComponent:USER_DB_FILE_NAME];
}

+ (NSString *)pathForAllConfigFile {
	return [[self pathForAllUsers] stringByAppendingPathComponent:ALL_CONFIG_FILE_NAME];
}

+ (NSString *)pathForConfigFileOfUser:(NSString *)userId {
	return [[self pathForUserId:userId] stringByAppendingPathComponent:USER_CONFIG_FILE_NAME];
}

+ (NSString *)fileNameForUrlStr:(NSString *)urlStr {
	return [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"%"];
}

+ (NSString *)fileNameByAppending:(NSString *)appendStr 
				 inMainOfFileName:(NSString *)fileName {
	NSString *fileNameMain = [fileName stringByDeletingPathExtension];
	NSString *fileNameExtention = [fileName pathExtension];
	return [[fileNameMain stringByAppendingString:appendStr] 
			stringByAppendingPathExtension:fileNameExtention];
}

+(void)checkAndMakeMyDocumentPathForUser:(NSString *)userId{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建我文件夹相关目录
    NSArray *myDocTypeArray = [NSArray arrayWithObjects:FILE_TYPE_CACHE_DOC,FILE_TYPE_CACHE_PIC, FILE_TYPE_CACHE_MUSIC,FILE_TYPE_CACHE_VIDEO,FILE_TYPE_CACHE_OTHER, nil];
    for (NSString *docTypeStr in myDocTypeArray) {
        NSString *typePath = [self pathForDocumentType:docTypeStr userId:userId];
        BOOL isDirectory = TRUE;
        if (![fileManager fileExistsAtPath:typePath isDirectory:&isDirectory]) {
            [fileManager createDirectoryAtPath:typePath withIntermediateDirectories:TRUE attributes:nil error:nil];
        }
    }
    
    //创建我的下载缓存文件夹
    NSString *downloadTempPath = [self pathForMyDownloadTempWithId:userId];
    BOOL isDirectory = TRUE;
    if (![fileManager fileExistsAtPath:downloadTempPath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:downloadTempPath withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
}

+ (NSString *)pathForMyDocumentWithId:(NSString *)userId {
    return [[self pathForUserId:userId] stringByAppendingPathComponent:FILE_CACHE_DOCUMENT];
}

+ (NSString *)pathForMyDownloadTempWithId:(NSString *)userId {
    return [[self pathForUserId:userId] stringByAppendingPathComponent:FILE_CACHE_TEMP];
}

//获取我的文件夹下各类型的子目录
+ (NSString *)pathForDocumentType:(NSString *)type userId:(NSString *)userId {
    NSString *myDocRoot = [self pathForMyDocumentWithId:userId];
	return [myDocRoot stringByAppendingPathComponent:type];
}

+ (NSString*)checkAndMakePathsForUser:(NSString *)userId {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    //huang
    //此两段代码是一样的功能  MEDIA_TYPE_CACHE_IMAGE = MEDIA_TYPE_GENERAL_IMAGE
	//一般图像，caches下面
    //路径  /Users/andy/Library/Application Support/iPhone Simulator/6.1/Applications/A4DD2556-29E3-4B9E-9942-8FED0BB7BC7E/Documents/11907/images
	NSString *checkingPath = [self pathForMediaType:MEDIA_TYPE_CACHE_IMAGE userId:userId];
	BOOL isDirectory = TRUE;
	if (![fileManager fileExistsAtPath:checkingPath isDirectory:&isDirectory]) {
		[fileManager createDirectoryAtPath:checkingPath withIntermediateDirectories:TRUE attributes:nil error:nil];
	}

    //一般图像，documents目录
//	checkingPath = [self pathForMediaType:MEDIA_TYPE_GENERAL_IMAGE userId:userId];
//	if (![fileManager fileExistsAtPath:checkingPath isDirectory:&isDirectory]) {
//		[fileManager createDirectoryAtPath:checkingPath withIntermediateDirectories:TRUE attributes:nil error:nil];
//	}
    
    return checkingPath;
}
+ (NSString*)CheckAndMakeAudioPathForTarget:(NSString*)userId{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *checkingPath = [self pathForMediaType:MEDIA_TYPE_CACHE_AUDIO userId:userId];
	BOOL isDirectory = TRUE;
	if (![fileManager fileExistsAtPath:checkingPath isDirectory:&isDirectory]) {
		[fileManager createDirectoryAtPath:checkingPath withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
    return checkingPath;
}
@end
