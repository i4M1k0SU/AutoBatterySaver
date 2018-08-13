#import "_CDBatterySaver.h"
#import "AXSettings.h"
//#import "_CDSystemMonitor.h"
//#import "SBUIController.h"
//#import <CoreDuet/CoreDuet.h>

//extern "C" Boolean _AXSReduceMotionEnabled();
//extern "C" void _AXSSetReduceMotionEnabled(BOOL enabled);

static NSString *const kSettingsPath = @"/var/mobile/Library/Preferences/jp.i4m1k0su.autobatterysaver.plist";
NSMutableDictionary *preferences;
BOOL isEnabled = NO;
int chargeRemainingBattery = 80;
int dischargeRemainingBattery = 30;

BOOL isOnAC = NO;
int nowRemainingBattery = 0;

_CDBatterySaver *batterySaver = [NSClassFromString(@"_CDBatterySaver") new];
AXSettings *axSettings = [NSClassFromString(@"AXSettings") new];
//_CDSystemMonitor *systemMonitor = [[NSClassFromString(@"_CDSystemMonitor") alloc] init];

//設定ファイルロード
static void loadPreferences() {

	//設定ファイルの有無チェック
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath: kSettingsPath]) {
		//ない場合にデフォルト設定を作成
		NSDictionary *defaultPreferences = @{
			@"sw_enable":@YES,
			@"lst_discharge_remaining_battery":@30,
			@"lst_charge_remaining_battery":@80
		};

		preferences = [[NSMutableDictionary alloc] initWithDictionary: defaultPreferences];
		[defaultPreferences release];

		#ifdef DEBUG
			if (![preferences writeToFile: kSettingsPath atomically: YES]) {
				 NSLog(@"ファイルの書き込みに失敗");
			}
		#else
			[preferences writeToFile: kSettingsPath atomically: YES];
		#endif
	} else {
			//あれば読み込み
			preferences = [[NSMutableDictionary alloc] initWithContentsOfFile: kSettingsPath];
	}
	isEnabled = [[preferences objectForKey:@"sw_enable"]boolValue];
	dischargeRemainingBattery = [[preferences objectForKey:@"lst_discharge_remaining_battery"]intValue];
	chargeRemainingBattery = [[preferences objectForKey:@"lst_charge_remaining_battery"]intValue];

}


//起動時の処理
%ctor {
	loadPreferences();
}

%hook SBUIController
	- (void)updateBatteryState:(id)arg1 {
		%orig;
		if (!isEnabled) {
			return;
		}

		BOOL isLowPowerModeEnabled = [batterySaver getPowerMode] == 1;

		// 電源が接続されている時
		if (isOnAC) {
			// 充電時は常に無効
			if (chargeRemainingBattery <= 0) {
				if (isLowPowerModeEnabled) {
					[batterySaver setMode: 0];
				}
			}
			else {
				// 充電時は100%以外常に有効
				if (chargeRemainingBattery == 99 && nowRemainingBattery <= chargeRemainingBattery) {
					if (!isLowPowerModeEnabled) {
						[batterySaver setMode: 1];
					}
				}
				// 通常動作
				else if (nowRemainingBattery >= chargeRemainingBattery) {
					if (isLowPowerModeEnabled) {
						[batterySaver setMode: 0];
						//[systemMonitor handleBatterySaverNotification: 0];
					}
				}
			}
		}
		// 電池駆動の時
		else {
			// 現在の電池残量と設定値を比較して電池残量が小さい場合に
			if (nowRemainingBattery <= dischargeRemainingBattery) {
				if (!isLowPowerModeEnabled) {
					[batterySaver setMode: 1];
				}
			}
		}
	}

	- (int) batteryCapacityAsPercentage {
		nowRemainingBattery = %orig;
		return nowRemainingBattery;
	}

	- (BOOL)isOnAC {
		isOnAC = %orig;
		return isOnAC;
	}
%end

%hook _CDBatterySaver
	- (long long)setMode:(long long)arg1 {
		// オプション判定
		if (true) {
			if (arg1 == 1) {
				[axSettings setReduceMotionEnabled: YES];
			}
			else {
				[axSettings setReduceMotionEnabled: NO];
			}
		}
		return %orig(arg1);
	}
%end
