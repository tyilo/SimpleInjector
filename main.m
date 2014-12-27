#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include "task_vaccine/task_vaccine.h"

kern_return_t inject_lib(pid_t pid, char *lib) {
	task_t task;
	kern_return_t ret = task_for_pid(mach_task_self(), pid, &task);
	if(ret != KERN_SUCCESS) {
		printf("task_for_pid() failed: %s\n", mach_error_string(ret));
		return ret;
	}

	ret = task_vaccine(task, lib);
	if(ret != KERN_SUCCESS) {
		printf("task_vaccine() failed: %s\n", mach_error_string(ret));
		return ret;
	}

	return KERN_SUCCESS;
}

int main(int argc, char *argv[]) {
	@autoreleasepool {
		if(argc != 3) {
			printf("Usage: SimpleInjector bundleId lib-path\n");
			return 1;
		}

		NSString *bid = [NSString stringWithUTF8String:argv[1]];
		char *lib = argv[2];

		NSMutableArray *appsInjected = [NSMutableArray new];

		while(true) {
			NSArray *apps = [NSRunningApplication
				runningApplicationsWithBundleIdentifier:bid];

			if([apps count] == 0) {
				[appsInjected removeAllObjects];
			} else {
				for(NSRunningApplication *app in apps) {
					pid_t pid = app.processIdentifier;

					if([appsInjected containsObject:@(pid)]) {
						continue;
					}

					if(inject_lib(pid, lib) == KERN_SUCCESS) {
						printf("Injected lib successfully into process with pid: %d\n", pid);

						[appsInjected addObject:@(pid)];
					}
				}
			}

			sleep(1);
		}
	}
}
