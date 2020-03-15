#import <os/log.h>
#import "Tweak.h"
// #import <saisaki-Swift.h>

#define log(s, ...) os_log(OS_LOG_DEFAULT, "saisaki " s, ##__VA_ARGS__)

static id<LockScreenWrapper> lockscreenWrapper;
static id<WallpaperViewWrapper> wallpaperWrapper;

%hook SBCoverSheetPresentationManager

-(void)setCoverSheetPresented:(BOOL)presented animated:(BOOL)arg2 options:(unsigned long long)arg3 withCompletion:(/*^block*/id)arg4 {
    if (!presented) {
        SBLockScreenManager *lsManager = [%c(SBLockScreenManager) sharedInstance];
        [lsManager _createAuthenticationAssertion]; // fixes touchID bug
        bool hasUnlockAction = [lsManager unlockActionBlock] != nil;
        if ([lsManager _isPasscodeVisible]) {
            [lsManager _runUnlockActionBlock:true]; // unlock request from notif. center
            [lsManager setPasscodeVisible:false animated:true];
        }
        log("dismissing...");
        [lockscreenWrapper unlockSuccessful:true completion:^(BOOL animated) {
            log("done unlocking");
            bool shouldDoNormalAnimation = !animated || hasUnlockAction;
            log("shouldDoNormalAnimation %d", shouldDoNormalAnimation);
            %orig(false, shouldDoNormalAnimation, arg3, arg4);
        }];
    } else {
        [lockscreenWrapper lockScreenWillAppear];
        %orig;
        log("will appear");
    }
}

%end

%hook SBWallpaperController
%property (nonatomic, retain) SBFWallpaperView *ssk_wallpaperView;

-(SBFWallpaperView*)vendWallpaperViewForConfiguration:(id)arg1 forVariant:(long long)arg2 shared:(BOOL)arg3 options:(unsigned long long)arg4 {
    if (!lockscreenWrapper) {
        LockScreenManager *manager = [[LockScreenManager alloc] initWithWallpaperProvider:
                                                    self];
        lockscreenWrapper = manager;
        wallpaperWrapper = manager;
    }
    if (self.ssk_wallpaperView == nil) {
        CGRect bounds = UIScreen.mainScreen.bounds;
        WrapperWallpaperView *ovr = [[%c(WrapperWallpaperView) alloc] initWithFrame:bounds configuration:arg1 variant:arg2 cacheGroup:nil delegate:self options:arg4];
        self.ssk_wallpaperView = ovr;
    }

    return self.ssk_wallpaperView;
}
-(id)_blurViewsForVariant:(long long)arg1 { // workaround the variant bug where variant = 0 unless reset wallpaper
    NSHashTable *hs = [self valueForKey:@"_homescreenBlurViews"];
    NSHashTable *ls = [self valueForKey:@"_lockscreenBlurViews"];
    NSHashTable *copy = ls.copy;
    [copy unionHashTable:hs];
    return copy;
}

-(void)cleanupOldSharedWallpaper:(id)arg1 lockSreenWallpaper:(id)arg2 homeScreenWallpaper:(id)arg3 {
    if ([arg1 isKindOfClass:[%c(WrapperWallpaperView) class]]) {
        return; // ios 13 cleans up our old wallpaper. maybe we don't want that
    }
    %orig;
}

%new
-(void)updateWallpaper {
    [self _updateBlurImagesForVariant:self.ssk_wallpaperView.variant]; // update cache images

}

%new
-(UIView*)wallpaperView {
    return self.ssk_wallpaperView;
}
%end

%subclass WrapperWallpaperView : SBFWallpaperView
-(id)initWithFrame:(CGRect)arg1 configuration:(id)arg2 variant:(long long)arg3 cacheGroup:(id)arg4 delegate:(id)arg5 options:(unsigned long long)arg6 {
    [wallpaperWrapper initializeWithFrame:arg1];
    return %orig;
}


%group ios12
-(id)initWithFrame:(CGRect)arg1 variant:(long long)arg2 wallpaperSettingsProvider:(id)arg3 {
    [wallpaperWrapper initializeWithFrame:arg1];
    return %orig;
}
%end

-(id)_computeAverageColor {
    return [wallpaperWrapper overridenWallpaperColor];
}

-(id)averageColorInRect:(CGRect)arg1 withSmudgeRadius:(double)arg2 {
    return [wallpaperWrapper overridenWallpaperColor];
}

-(id)snapshotImage {
    id res = [wallpaperWrapper snapshotImage];
    return res;
}

// disable caching blur view images
-(id)cacheGroup {
    return nil;
}
%end

%ctor {
    if (@available(ios 13.0, *)) {
        log("loaded ios >= 13.0");
        %init();
    } else {
        log("loaded ios < 13.0");
        %init(ios12);
    }
}