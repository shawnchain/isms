//==============================================================================
//	Created on 2008-1-13
//==============================================================================
//	$Id$
//==============================================================================
// Credit to the dock app
//==============================================================================

#include <signal.h>
// #include <kvm.h>
#include <fcntl.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#import "Log.h"
#import <Foundation/Foundation.h>

/*
pid_t springboard_pid() {
	uint32_t i;
	size_t length;
	int32_t err, count;
	struct kinfo_proc *process_buffer;
	struct kinfo_proc *kp;
	int mib[ 3 ] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL };
	pid_t spring_pid;
	int loop;
	//int argmax;

	spring_pid = -1;

	sysctl(mib, 3, NULL, &length, NULL, 0);

	if (length == 0)
		return -1;

	process_buffer = (struct kinfo_proc *)malloc(length);

	for (i = 0; i < 60; ++i) {
		// in the event of inordinate system load, transient sysctl() failures are
		// possible.  retry for up to one minute if necessary.
		if ( ! (err = sysctl(mib, 3, process_buffer, &length, NULL, 0) ))
			break;
		sleep( 1);
	}

	if (err) {
		free(process_buffer);
		return -1;
	}

	count = length / sizeof(struct kinfo_proc);

	kp = process_buffer;

#ifdef DEBUG
	fprintf(stderr, "PID scan: found %d visible procs\n", count);
#endif            

	for (loop = 0; (loop < count) && (spring_pid == -1); loop++) {
#ifdef DEBUG
		fprintf(stderr, "PID: checking process %d (%s)\n", kp->kp_proc.p_pid,
				kp->kp_proc.p_comm);
#endif              

		if (!strcasecmp(kp->kp_proc.p_comm, "SpringBoard")) {
			spring_pid = kp->kp_proc.p_pid;
		}
		kp++;
	}

	free(process_buffer);

	return spring_pid;
}
*/
//
//int springboard_restart2() {
//	pid_t spring_pid;
//
//	spring_pid = springboard_pid();
//	if (spring_pid != -1) {
//		//kill(spring_pid, SIGHUP);
//		kill(spring_pid, 9);
//		return 1;
//	} else
//		return 0;
//}

int springboard_restart() {
	LOG(@"Forking child process to restart springboard");
	pid_t child = fork();
	if(child == 0){
		LOG(@"Child Process - Restarting springboard");
		// Now we're in child process
		execlp("/bin/launchctl","launchctl","stop","com.apple.SpringBoard",NULL);
		sleep(1);
		exit(1);
	}
	LOG(@"Child process %d forked, suiciding...",child);
	//exit(1);
	return 0;
}

NSString* osVersionString(){
	return [[NSProcessInfo processInfo] operatingSystemVersionString];
}

static int _osVersionValue = -1; 
int osVersion(){
	if(_osVersionValue < 0){
		// We assume the strings is as:
		// Version 1.x.x (Build XXXX)
		NSString* s = osVersionString();
		if([s hasPrefix:@"Version "]){
			if([s length] >= 13 ){
				char buf[] = {0x0,0x0};
				buf[0] = [s characterAtIndex:8];
				int i1 = atoi(buf);
				buf[0] = [s characterAtIndex:10];
				int i2 = atoi(buf);
				buf[0] = [s characterAtIndex:12];
				int i3 = atoi(buf);
				_osVersionValue = i1 * 100 + i2 * 10 + i3;
				DBG(@"OS Version is %d",_osVersionValue);
				return _osVersionValue;
			}
		}
		_osVersionValue = 0;
	}
	return _osVersionValue;
}
