#import <os/log.h>
#import "Tweak.h"
// #import <saisaki-Swift.h>

#define log(s, ...) os_log(OS_LOG_DEFAULT, "saisaki " s, ##__VA_ARGS__)

static id<LockScreenWrapper> lockscreenWrapper;
static id<WallpaperViewWrapper> wallpaperWrapper;

%hook SBCoverSheetPresentationManager

-(void)setCoverSheetPresented:(BOOL)presented animated:(BOOL)animated options:(unsigned long long)arg3 withCompletion:(/*^block*/id)arg4 {
    if (!presented) {
        [lockscreenWrapper unlockSuccessful:true];
    } else {
        [lockscreenWrapper lockScreenWillAppear];
    }
    %orig;
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

    if (!self.ssk_wallpaperView) {
        SBFWallpaperView *org = %orig;
        WrapperWallpaperView *ovr = [[%c(WrapperWallpaperView) alloc] initWithFrame:org.frame variant:arg2 wallpaperSettingsProvider:self];
        self.ssk_wallpaperView = ovr;
    }

    log("vending variant %lld", arg2);
    
    return self.ssk_wallpaperView;
}
-(id)_blurViewsForVariant:(long long)arg1 { // workaround the variant bug where variant = 0 unless reset wallpaper
    NSHashTable *ls = [self valueForKey:@"_homescreenBlurViews"];
    return ls.count == 0 ? [self valueForKey:@"_lockscreenBlurViews"] : ls;
}

%new
-(void)updateWallpaper {
    [self _updateBlurImagesForVariant:self.ssk_wallpaperView.variant];

}

%new
-(UIView*)wallpaperView {
    // UIView *wpView = [self sharedWallpaperView];
    // // log("wallpaperView %{public}@", wpView);
    // return wpView;
    return self.ssk_wallpaperView;
}
%end

%subclass WrapperWallpaperView : SBFWallpaperView

-(id)initWithFrame:(CGRect)arg1 variant:(long long)arg2 wallpaperSettingsProvider:(id)arg3 {
    [wallpaperWrapper initializeWithFrame:arg1];
    return %orig;
}

-(id)_computeAverageColor {
    return [wallpaperWrapper overridenWallpaperColor];
}

-(id)averageColorInRect:(CGRect)arg1 withSmudgeRadius:(double)arg2 {
    return [wallpaperWrapper overridenWallpaperColor];
}

-(id)snapshotImage {
    id res = [wallpaperWrapper snapshotImage];
    log("snapshot %{public}@", res);
    return res;
}
%end

%hook SBCoverSheetPrimarySlidingViewController

// -(void)_beginTransitionFromAppeared:(BOOL)appeared {
//     // NO-OP
//     log("sliding view controller %@appeared", appeared ? @"" : @"NOT ");
//     if (!appeared) {
//         %orig;
//     }
// }

%end

%ctor {
    log("loaded");
}