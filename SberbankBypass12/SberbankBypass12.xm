// See http://iphonedevwiki.net/index.php/Logos

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

%hook NSFileManager
    - (BOOL)fileExistsAtPath:(NSString *)path {
        NSArray *jbChecks = [NSArray arrayWithObjects:
                                @"/Applications/Cydia.app",
                                @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                @"/bin/bash",
                                @"/usr/sbin/sshd",
                                @"/etc/apt",
                                @"/usr/bin/ssh",
                                @"/bin/sh",
                                @"/Applications/RockApp.app",
                                @"/Applications/Icy.app",
                                @"/usr/bin/sshd",
                                @"/usr/libexec/sftp-server",
                                @"/Applications/WinterBoard.app",
                                @"/Applications/SBSettings.app",
                                @"/Applications/MxTube.app",
                                @"/Applications/IntelliScreen.app",
                                @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                                @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                                @"/private/var/lib/apt",
                                @"/private/var/stash",
                                @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                                @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                                @"/private/var/tmp/cydia.log",
                                @"/private/var/lib/cydia",
                                @"/etc/clutch.conf",
                                @"/var/cache/clutch.plist",
                                @"/etc/clutch_cracked.plist",
                                @"/var/cache/clutch_cracked.plist",
                                @"/var/lib/clutch/overdrive.dylib",
                                @"/var/root/Documents/Cracked/",
                                @"/var/mobile/Applications/JailbreakChecking",
                                @"/System/Library/Frameworks/Foundation.framework/Foundation",
                                @"/Applications/FakeCarrier.app",
                                @"/Applications/blackra1n.app",
                                @"/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate",
                                @"/Library/Frameworks/CydiaSubstrate.framework/Libraries/SubstrateLoader.dylib",
                                @"/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                                @"/Library/MobileSubstrate/DynamicLibraries/ProtectMyPrivacy.dylib",
                                @"/Library/MobileSubstrate/DynamicLibraries/WeeLoader.dylib",
                                @"/Library/MobileSubstrate/DynamicLibraries/xCon.dylib",
                                @"/etc/ssh/sshd_config",
                                @"/usr/binsshd",
                                @"/usr/libexec/cydia",
                                @"/usr/libexec/ssh-keysign",
                                @"/usr/sbinsshd",
                                @"/var/cache/apt",
                                @"/var/lib/apt",
                                @"/var/lib/cydia",
                                @"/system/app/Superuser.apk",
                                @"/private/var/mobileLibrary/SBSettingsThemes",
                                @"/private/var/mobile/Library/SBSettings/Themes",
                                @"/var/log/syslog",
                                @"/var/tmp/cydia.log",
                                nil
                            ];

        for (NSString *check in jbChecks) {
            if ([check isEqualToString: path]) {
                NSLog(@"JB Check return NO for path: %@", path);
                return NO;
            }
        }

        return %orig;
    }

    - (BOOL)createDirectoryAtPath:(NSString *)path
                   attributes:(NSDictionary *)attributes {
        NSString *jbDetectionPath = @"/var/mobile/Applications/JailbreakChecking";

        NSLog(@"App trying to create directory at path: %@", path);

        if ([jbDetectionPath isEqualToString: path]) {
            NSLog(@"Access denied for path: %@", path);
            return NO;
        }

        return %orig;
    }

    - (BOOL)createDirectoryAtPath:(NSString *)path
    withIntermediateDirectories:(BOOL)createIntermediates
                     attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes
                          error:(NSError * _Nullable *)error {
        NSString *jbDetectionPath = @"/var/mobile/Applications/JailbreakChecking";
        NSString *jbDetectionBypassPath = @"/var/mobile/Applications1/JailbreakChecking";

        NSLog(@"App trying to create directory at path: %@", path);

        if ([jbDetectionPath isEqualToString: path]) {
            
            NSError * _Nullable __autoreleasing errorFromOrig;
            BOOL result = %orig(jbDetectionBypassPath, createIntermediates, attributes, &errorFromOrig);

            *error = errorFromOrig;
            
            NSLog(@"Access denied for path: %@", path);
            
            NSLog(@"Result of removeItemAtPath:");
            NSLog(@"Result: %d", (int)result);
            NSLog(@"Error: %@", errorFromOrig);
            
            return NO;
        }

        return %orig;
    }

    - (BOOL)removeItemAtPath:(NSString *)path
                   error:(NSError * _Nullable *)error {
        NSLog(@"Removing item at path: %@", path);

        NSString *jbDetectionPath = @"/var/mobile/Applications/JailbreakChecking";
        NSString *jbDetectionBypassPath = @"/var/mobile/Applications1/JailbreakChecking";

        if ([jbDetectionPath isEqualToString: path]) {
            NSLog(@"JB Detecion tries remove item at path: %@", path);

            NSLog(@"Trying bypass JB Detection with path: %@", jbDetectionBypassPath);

            NSError * _Nullable __autoreleasing errorFromOrig;
            BOOL result = %orig(jbDetectionBypassPath, &errorFromOrig);

            *error = errorFromOrig;

            NSLog(@"Result of removeItemAtPath:");
            NSLog(@"Result: %d", (int)result);
            NSLog(@"Error: %@", errorFromOrig);

            return result;
        }

        return %orig;
    }
%end

%hook CLSFileManager

%end
