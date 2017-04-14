### SDWebImage 扩展
 主要是为主项目工程唯一引用依赖更新SDWebImage使用，并对SDWebImage针对自身项目增加功能API(包括小视频的下载与读取处理，以及一些设置图片的便利方法API)

> * SDWebImage 更新到4.0 后，本次更新升级，个人觉得，对代码优化做了进一步升级，相隔两年时间，支持了更多设备，有了适当清除内存，优化用户体验
> * 支持GIF 更方便的接入实现

*  SDWebImage版本,详见 cl_SDWebImageAdditions.podspec
>  * "SDWebImage/Core", '~> 4.0.0' 
>  * "SDWebImage/GIF", '~> 4.0.0' 
>  * "SDWebImage/WebP", '~> 4.0.0' 
>  * "SDWebImage/MapKit", '~> 4.0.0' 

* BPSDImageManagerAdditions

> SDWebImageManager、UIImageView、UIButton category扩展,支持button图片加载，以及SDWebImageManager 一些拓展方法（待完善）

 ``` objective-c

//SDWebImageManager (fix)

- (BOOL)hasCacheForURL:(NSURL *)url;
- (UIImage *)cacheImageForURL:(NSURL *)url;
- (NSString *)cachedThumbLinkWithImageLink:(NSString *)link;

//UIImageView (fix)
- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

// UIButton (fix)
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

```

* CKImageContentType

> 转换支持之前的imageContentType,之前上传图片夹带图片类型的参数，通过此次4.0版本进行枚举之间的转换

* CKSDImageCacheAdditions
* CKSDWebImageDownloaderOperationAdditions
* CKUIImageAdditions
* UIImage+MP4

> 利用SDWebImage 对小视频存储和读取的扩展，主要是用runtime对原有方法进行hook后针视频类型做存储优化处理包括：

>> 视频类型不存储到 MemeoryCache

>> 不做硬解码图片处理

>> 从diskCache 中读取后不加入到 MemeoryCache