KIFHarness - Easy and Sustainable Testing With KIF
==============================================================

KIFHarness is primarily intended as a template for easily adding KIF to your iOS application. Many of the awkward design decisions have been made for you, with a variety of scripts in place to minimize the Xcode hoop jumping necessary.

Many parts of the installation instructions for KIFHarness parallel those of KIF itself. The main difference with (and motivation for) KIFHarness is in the way it handles application integration. The KIF instructions suggest duplicating your application target in order to create a special "testing version". The multiple targets approach quickly becomes cumbersome to maintain, especially in a heavily shared code base, or in large teams.

KIFHarness isolates tests in their own project and target; adding classes to your main project does not require remembering to also add them to the test target. The direct integration with your application source is identical to the standard KIF approach, and the heavy lifting of conditionally linking the KIF library is handled by a few pre and post build scheme scripts.

Installation
------------

There are a lot of steps here, but if you just follow the steps, everything _should_ "just work". This is still a work in progress, any feedback is very much welcome.

#### Download KIFHarness

Because it is intended as a template, you _will_ be modifying the KIFHarness project after it is integrated - for this reason, it is recommended that you do NOT install KIFHarness as a git submodule.

You can download a zipped copy of the project here [ADD ZIP LINK]

#### Copy KIFHarness to your project directory

There are three directories located under the `KIFHarness` directory that need to be copied to the root of your projects source directory: 

	Configurations 
	KIF
	KIFHarnessTemplate

#### Get the KIF source

You'll notice that the KIF directory is empty - you can either include the KIF source directly, or setup a submodule, depending on the way your project is setup.

###### Directly include the KIF source

Download [the zipped source](https://github.com/square/KIF/archive/master.zip) from the KIF repo. Unarchive and copy to `/path/to/MyApplicationSource/KIF`
	
###### KIF Submodule
	cd /path/to/MyApplicationSource
	git submodule add https://github.com/square/KIF.git KIF
	
#### Add KIFHarness and friends to your project

Let your project know about KIFHarness by adding the KIFHarness project into a workspace along with your main project. Find the KIFHarness.xcodeproj file at `/path/to/MyApplicationSource/KIFHarnessTemplate` and drag it into the Project Navigator.

Add the `Configurations` directory to your project by dragging the folder to the Project Navigator. **DO NOT** add them to a target. I know this is unusual, but these files are necessary for some configuration, but you do not want them to be copied into your application bundle.

[ADD SCREENSHOT of an unselected target]

#### Setup your configurations

KIFHarness is designed to leverage xcconfig files to conditionally link the KIF and KIFHarness libraries for testing only.

Click on your project in the Project Navigator, make sure the project is highlighted under `PROJECT` in the editor pane, then choose the `Info` tab. If you haven't changed them, you should see two configurations, `Debug` and `Release`. Expand the detail disclosures, and to the right of your project, choose "Config-Merged" from the drop downs for both `Debug` and `Release`

[ADD SCREENSHOT of configuration screen]

#### Setup your testing scheme

Choose Product->Manage Schemes… from the menu bar. Click the scheme you use to build your application, then click the gear at the bottom and choose `Duplicate`. Change the name of the new scheme to something other than `Copy of YourScheme`. 

In the left column, expand the Build section and choose `Pre-actions`, then `New Run Script Action`. Select your target from the `Provide build settings from` drop down and copy the following into the script box:

	ruby "${SRCROOT}/Configurations/configurations.rb" --merge Config-KIF.xcconfig "${SRCROOT}/Configurations"

Add a new Post-action script, and copy the following:

	ruby "${SRCROOT}/Configurations/configurations.rb" --reset "${SRCROOT}/Configurations"
	
Click the `Build` action. Click the add button and under target and select the KIFHarness library. Be sure to drag it above your project, then uncheck the Parallelize Build checkbox.
	
#### Ensure your configurations are playing nicely

Xcode resolves build settings by merging them in the following order iOS Default, Config Files, Project Settings, Target Settings. Settings defined later in the order override settings defined earlier. In order for settings to inherit values defined at higher levels you must include `$(inherited)` in the value.

KIFHarness requires that build settings inherit the values for `Preprocessor Macros`, `Header Search Paths` and `Other Linker Flags` (or `GCC_PREPROCESSOR_DEFINITIONS`, `HEADER_SEARCH_PATHS` and 	`OTHER_LDFLAGS` if you prefer the raw GCC flags).

[ADD SCREENSHOT]

	
#### Add the testing code to your application delegate

Just like in the KIF example, you'll want to add the following code to your application delegate

	#if RUN_KIF_TESTS
	#import "KIFHarness.h"
	#endif

and the following code to the end of its `-application:didFinishLaunchingWithOptions:` method

	#if RUN_KIF_TESTS
    	[[KIFHarness sharedInstance] startTestingWithCompletionBlock:^{
			// Exit after the tests complete so that CI knows we're done
			exit([[KIFHarness sharedInstance] failureCount]);
    	}];
	#endif
	
#### Write some tests!

At this point, KIFHarness should be ready to go! Choose your testing target and run it with Command+R. If KIFHarness has been added successfully, your application should build without errors and quit abruptly. You should see a log in the console that is something like `Running KIF Tests With KIFHarness!`. At this point, I suggest heading over to [KIF Documentation](https://github.com/square/KIF) and learning a bit about writing KIF tests.
	

#### Bonus: Write tests without cleaning every build
	
Unfortunately, as byproduct of the way we have the project setup, Xcode often won't include your latest testing code each time you run the app - you'll need to build clean every time.  This can be incredibly frustrating, and often has me chasing my own tail for several minutes before I remember to clean.  This can be solved with some more shell scripting hoop jumping - just add the following to a pre-build action in your testing scheme.
	
	file_list=`xcodebuild -project "$PROJECT_FILE_PATH" -target "$TARGET_NAME" -sdk "$SDKROOT" -configuration "$CONFIGURATION" -showBuildSettings | grep "LINK_FILE_LIST_"$BUILD_VARIANTS"_"$NATIVE_ARCH | sed s/[^=]*\=\ //`
	touch $file_list