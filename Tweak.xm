#import <SpringBoard/SpringBoard.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define BEEPPlist @"/var/mobile/Library/Preferences/com.ziph0n.beepbeep.plist"
#define BEEPIOS8 @"/System/Library/Audio/UISounds/connect_power.caf"
#define BEEP @"/System/Library/Audio/UISounds/beep-beep.caf"

NSURL *beepios8url = [NSURL fileURLWithPath:[NSString stringWithFormat:BEEPIOS8]];
NSURL *beepurl = [NSURL fileURLWithPath:[NSString stringWithFormat:BEEP]];

static AVAudioPlayer *audioPlayer; // Change to static to solve problem on iOS 10 no sound
static int isFirstTimeAfterRespring = 0;

@interface SBUIController : NSObject
    -(BOOL)isOnAC;
@end

%hook SpringBoard
-(void) applicationDidFinishLaunching:(id)arg {
    isFirstTimeAfterRespring = -1;
    %orig(arg);
}
%end

%hook SBUIController

// Below iOS 9
-(void)_indicateConnectedToPower {

    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:BEEPPlist];

    NSString *currentSound = [prefs objectForKey:@"currentSound"];
    if ([currentSound length] > 3) { currentSound = [currentSound substringToIndex:[currentSound length] - 4]; }
    NSString *mySoundPath = [[NSBundle bundleWithPath:@"/Library/Application Support/BeepBeep/Sounds/"] pathForResource:currentSound ofType:@"caf"];
    NSURL *mySoundURL = [[NSURL alloc] initFileURLWithPath:mySoundPath];

    BOOL enabled = [[prefs objectForKey:@"enabled"] boolValue];
    BOOL sound = [[prefs objectForKey:@"sound"] boolValue];
    BOOL custom = [[prefs objectForKey:@"custom"] boolValue];
    BOOL vibration = [[prefs objectForKey:@"vibration"] boolValue];

    AVAudioPlayer *audioPlayer;

    if (enabled) {

        if (sound) {

            if (!custom) {

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepios8url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepurl error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }

        }

        else if (custom) {

            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mySoundURL error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }
        }

        if (vibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [NSThread sleepForTimeInterval:0.5];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }

    }

    else if (!enabled) {

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepios8url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepurl error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [NSThread sleepForTimeInterval:0.5];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    }

}

-(void)playConnectedToPowerSoundIfNecessary{
    isFirstTimeAfterRespring += 1;

    // Respring first == 0 not come in
    // Respring and come in again == 1
    // Other == 0
    if(isFirstTimeAfterRespring <= 0){
        // prevent two sound after Respring
        return ;
    }
    if([self isOnAC] == NO){
        return ;
    }

    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:BEEPPlist];

    // NSString *mySoundPath = [[NSBundle bundleWithPath:@"/Library/Application Support/BeepBeep/Sounds/"] pathForResource:currentSound ofType:@"caf"];
    // NSURL *mySoundURL = [[NSURL alloc] initFileURLWithPath:mySoundPath];

    BOOL enabled = [[prefs objectForKey:@"enabled"] boolValue];
    BOOL sound = [[prefs objectForKey:@"sound"] boolValue];
    BOOL custom = [[prefs objectForKey:@"custom"] boolValue];
    BOOL vibration = [[prefs objectForKey:@"vibration"] boolValue];

    NSString *mySoundPath = [[NSBundle bundleWithPath:@"/Library/Application Support/BeepBeep/Sounds/"] pathForResource:@"iOS 6 Charging Sound" ofType:@"caf"];
    NSURL *mySoundURL = [[NSURL alloc] initFileURLWithPath:mySoundPath];

    if (enabled) {
        if (sound) {
            if (!custom) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepios8url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepurl error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }
        }
        else if (custom) {
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mySoundURL error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }
        }
        if (vibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [NSThread sleepForTimeInterval:0.5];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    else if (!enabled) {

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepios8url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else {
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepurl error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [NSThread sleepForTimeInterval:0.5];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    }
}


-(void) ACPowerChanged {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:BEEPPlist];

    BOOL enabled = [[prefs objectForKey:@"enabled"] boolValue];
    BOOL screen = [[prefs objectForKey:@"screen"] boolValue];

    if (enabled) {
        if (screen) {
            // doing nothing
        }
        else if (!screen) {
            %orig;
        }
    }
    else if (!enabled) {
        %orig;
    }

}

%end