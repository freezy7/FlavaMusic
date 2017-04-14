//
//  VGEDataModel.h
//  VGEUI
//
//  Created by Hunter Huang on 8/14/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGEDataResult.h"

@protocol VGEDataModelDelegate;

@interface VGEDataModel : NSObject {
    
}

@property (nonatomic, assign, readonly) BOOL loading;
@property (nonatomic, strong, readonly) id data;
@property (nonatomic, strong, readonly) VGEDataResult *result;
@property (nonatomic, strong, readonly) NSDate *lastUpdatedTime;
@property (nonatomic, weak) id<VGEDataModelDelegate> delegate;
@property (nonatomic, assign) BOOL loadInBackground; // YES by default
@property (nonatomic, assign) BOOL callDelegateOnMainThread; // YES by default

- (id)initWithDelegate:(id<VGEDataModelDelegate>)delegate;

/**
 return all the data parsed
 */
- (id)data;

/**
 continue to load data and never clear previous data
 */
- (void)startLoad;

/**
 clear previous data after load finished
 */
- (void)reload;

// should implemented by subclass
- (VGEDataResult *)loadData;
- (id)parseData:(id)data;  //loaded only at success (VGEDataResult is YES)
- (id)defaultData;         //loaded only at failed  (VGEDataResult is NO)

- (void)willFinishLoadOnMainThread;

@end

@protocol VGEDataModelDelegate <NSObject>

@optional
- (void)dataModelPrepareStart:(VGEDataModel *)model; //主线程同步调用
- (void)dataModelWillStart:(VGEDataModel *)model;
- (void)dataModelWillFinish:(VGEDataModel *)model;
- (void)dataModelDidFinish:(VGEDataModel *)model;

// provide for subclass to use
- (void)dataModelDidUpdate:(VGEDataModel *)model;

- (void)dataModelDidSuccess:(VGEDataModel *)model;
- (void)dataModelDidFail:(VGEDataModel *)model;

@end
