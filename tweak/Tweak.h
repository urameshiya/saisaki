#import <saisaki-Swift.h>

@protocol WallpaperProviding, WallpaperViewWrapper;
@class SBCoverSheetSlidingViewController;

@interface SBLockScreenManager
+(instancetype)sharedInstance;

-(void)_createAuthenticationAssertion;
-(void)setPasscodeVisible:(BOOL)arg1 animated:(BOOL)arg2;
-(void)_runUnlockActionBlock:(BOOL)arg1;
-(bool)_isPasscodeVisible;
-(id)unlockActionBlock;
-(void)setUnlockActionBlock:(id)arg1;
@end

@interface SBCoverSheetPresentationManager
-(void)_notifyDelegateWillDismiss;
-(void)coverSheetSlidingViewController:(id)arg1 committingToEndPresented:(BOOL)arg2 ;
-(void)_prepareForDismissalTransition;
-(void)_setTransitionProgress:(double)arg1 animated:(BOOL)arg2 gestureActive:(BOOL)arg3 coverSheetProgress:(double)arg4 completion:(/*^block*/id)arg5 ;
-(SBCoverSheetSlidingViewController *)coverSheetSlidingViewController;
-(void)coverSheetSlidingViewController:(id)arg1 prepareForDismissalTransitionForReversingTransition:(BOOL)arg2 forUserGesture:(BOOL)arg3 ;
@end

@interface SBCoverSheetSlidingViewController: UIViewController
-(SBCoverSheetPresentationManager*)delegate;
- (long long)dismissalSlidingMode;
-(void)setDismissalSlidingMode:(long long)arg;
-(void)_updateForLocation:(CGPoint)point interactive:(BOOL)interactive;
-(CGPoint)_finalLocationForTransitionToPresented:(BOOL)arg1;
-(void)_finishTransitionToPresented:(BOOL)presented animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3;
-(void)_transitionToViewControllerAppearState:(int)arg1 ifNeeded:(BOOL)arg2 forUserGesture:(BOOL)arg3;
@end

@interface SBFWallpaperView: UIView
@property (assign,nonatomic) long long variant;                                                                  //@synthesize variant=_variant - In the implementation block
// 12.4
-(id)initWithFrame:(CGRect)arg1 variant:(long long)arg2 wallpaperSettingsProvider:(id)arg3 ;
// 13
-(id)initWithFrame:(CGRect)arg1 configuration:(id)arg2 variant:(long long)arg3 cacheGroup:(id)arg4 delegate:(id)arg5 options:(unsigned long long)arg6 ;

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


