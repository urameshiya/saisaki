#import <saisaki-Swift.h>

@protocol WallpaperProviding, WallpaperViewWrapper;

@interface SBCoverSheetPresentationManager
@end

@interface SBFWallpaperView: UIView
@property (assign,nonatomic) long long variant;                                                                  //@synthesize variant=_variant - In the implementation block
-(id)initWithFrame:(CGRect)arg1 variant:(long long)arg2 wallpaperSettingsProvider:(id)arg3 ;

@end

@interface WrapperWallpaperView: SBFWallpaperView
@property (nonatomic, weak) id<WallpaperViewWrapper> wrapper;
@end

@interface SBWallpaperController: NSObject <WallpaperProviding>
+(instancetype)sharedInstance;
-(UIView *)sharedWallpaperView;

-(void)_reloadWallpaperAndFlushCaches:(BOOL)arg1 completionHandler:(/*^block*/id)arg2 ;
-(void)_reconfigureBlurViewsForVariant:(long long)arg1 ;
-(void)_updateBlurImagesForVariant:(long long)arg1 ;
-(id)_wallpaperViewForVariant:(long long)arg1 ;
-(id)_blurViewsForVariant:(long long)arg1 ;

// Hooked
@property (nonatomic, retain) SBFWallpaperView *ssk_wallpaperView;
@end


