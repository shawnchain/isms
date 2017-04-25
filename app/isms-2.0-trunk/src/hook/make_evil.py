#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# version 0.2, now with less broken and more useful!
# Aaron Zinman <azinman@media.mit.edu>

# take any .h from class_dump
# and this will generate a .m that overlaods the function with each method, logging input/output

# you get something like this
# 2007-09-24 02:44:44.183 MobilePhone[339:d03] PRE: (id) [Evil <PhoneCall: 0x166ee0> localizedLabel]
# 2007-09-24 02:44:44.187 MobilePhone[339:d03]    PRE: (int) [Evil <PhoneCall: 0x166ee0> _addressBookUid]
# 2007-09-24 02:44:44.190 MobilePhone[339:d03]    POST: returning -1
# 2007-09-24 02:44:44.208 MobilePhone[339:d03] POST: returning (null)
# 2007-09-24 02:44:44.323 MobilePhone[339:d03] PRE: (BOOL) [Evil <PhoneCall: 0x166ee0> isVoicemail]
# 2007-09-24 02:44:44.326 MobilePhone[339:d03] POST: returning b
# 2007-09-24 02:44:44.349 MobilePhone[339:d03] PRE: (id) [Evil <PhoneCall: 0x166ee0> displayName]
# 2007-09-24 02:44:44.351 MobilePhone[339:d03]    PRE: (id) [Evil <PhoneCall: 0x166ee0>  _displayNameWithSeparator:  ]
# 2007-09-24 02:44:44.353 MobilePhone[339:d03]            PRE: (int) [Evil <PhoneCall: 0x166ee0> _addressBookUid]
# 2007-09-24 02:44:44.358 MobilePhone[339:d03]            POST: returning -1
# 2007-09-24 02:44:44.361 MobilePhone[339:d03]    POST: returning Voicemail

# WARNING: will overwrite any evil* file that exists... Catagory based .h , i.e. PhoneApplication-Testing, will
# not be smart enough to append


# How to use:

# class-dump -aAHIsS MobilePhone
# python make_evil PhoneCall.h
# arm-apple-darwin-gcc -g -W -Wall -D_REENTRANT -fno-common -c -o EvilPhoneCall.o EvilPhoneCall.m
# arm-apple-darwin-gcc -undefined define_a_way -dynamiclib -lobjc -framework CoreFoundation -framework Foundation -framework UIKit -o evilPhoneCall.dylib EvilPhoneCall.o

# to load dylib overriding MobilePhone:
# $ scp evilPhoneCall.dylib root@iphone:/root@192.168.1.10
# $ ssh root@iphone
# > $ /bin/launchctl unload /System/Library/LaunchDaemons/com.apple.SpringBoard.plist
# <kill any processes associated with springboard or mobilephone>
# > $ DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES=/evilPhoneCall.dylib /System/Library/CoreServices/SpringBoard.app/SpringBoard
# > $ DYLD_INSERT_LIBRARIES=/usr/lib/iSMSHook.dylib /System/Library/CoreServices/SpringBoard.app/SpringBoard
# > $ DYLD_INSERT_LIBRARIES=/Library/Frameworks/iBorer.framework/iBorer.dylib /System/Library/CoreServices/SpringBoard.app/SpringBoard

# > $ DYLD_INSERT_LIBRARIES=/usr/lib/iSMSHook.dylib:/Library/Frameworks/SummerBoard.framework/SummerBoard.dylib /System/Library/CoreServices/SpringBoard.app/SpringBoard

# > $ DYLD_INSERT_LIBRARIES=/Applications/iSMS/iSMSHook.dylib:/Library/Frameworks/SummerBoard.framework/SummerBoard.dylib /System/Library/CoreServices/SpringBoard.app/SpringBoard
# > $ /bin/launchctl load /System/Library/LaunchDaemons/com.apple.SpringBoard.plist

# congrats, you are now evil!



import sys, re, os

if len(sys.argv) != 2 or sys.argv[1][-1] != 'h':
	print "usage: %s classDump.h"
	sys.exit(1)


# specs at http://developer.apple.com/documentation/CoreFoundation/Conceptual/CFStrings/
# please correct my errors

def writeProperVarsOut(passedSet, passedTypes):
	for var in passedSet:
		if passedTypes[var] == 'struct CGSize':
			evil.write(', %s.width, %s.height' % (var, var) )
		elif passedTypes[var] == 'struct CGPoint':
			evil.write(', %s.x, %s.y' % (var, var) )
		elif passedTypes[var] == 'struct CGRect':
			evil.write(', %s.size.width, %s.size.height, %s.origin.x, %s.origin.y' % (var, var, var, var) )
		else:
			evil.write(', ' + var)



def writeProperFormatter(messageParamType):
	if messageParamType == 'id' or messageParamType.startswith('NS') or messageParamType.startswith('UI'):
		evil.write('%@')
	elif messageParamType == 'struct __CFArray *':
		evil.write('%@')
	elif messageParamType == 'struct CGPoint':
		evil.write('(x=%1.3f, y=%1.3f)')
	elif messageParamType == 'struct CGSize':
		evil.write('(w=%1.3f, h=%1.3f)')
	elif messageParamType == 'struct CGRect':
		evil.write('(CGRect: w=%1.3f, h=%1.3f @ x=%1.3f, y=%1.3f)')
	elif messageParamType == 'BOOL':
		evil.write('%d')
	elif messageParamType == 'unsigned char':
		evil.write('%c')
	elif messageParamType == 'char *':
		evil.write('%s')
	elif messageParamType == 'int' or messageParamType == 'long':
		evil.write('%d')
	elif messageParamType == 'int' or messageParamType == 'long':
		evil.write('%d')
	elif messageParamType == 'long long':
		evil.write('%qi')
	elif messageParamType == 'unsigned long long':
		evil.write('%qu')
	elif messageParamType == 'unsigned long':
		evil.write('0x%x')
	elif messageParamType == 'short':
		evil.write('%hi')
	elif messageParamType == 'unsigned short':
		evil.write('%hu')
	elif messageParamType == 'unichar':
		evil.write('%C')
	elif messageParamType == 'unichar *':
		evil.write('%S')
	elif messageParamType == 'void *':
		evil.write('%p')
	elif messageParamType == 'float' or messageParamType == 'double':
		evil.write('%f')
	else:
		evil.write('(' + messageParamType + ')@0x%x')

f = open(sys.argv[1], 'r')

className = None
evilTestFileName = None
evil = None

for line in f:
	if line.startswith("@interface"):
		tok = line.split(' ')
		className = tok[1]
		evilTestFileName = 'Evil' + className + ".m"
		evilClassName = 'Evil' + className
		evil = open(evilTestFileName, 'w')
		evil.write('#import "' + sys.argv[1] + '"\n\n')
		evil.write('static int __evilTabCount = 0;\n\n')
		evil.write('@interface ' + evilClassName + ' : ' + className + '\n{ }\n@end\n\n')
		evil.write('@implementation ' + evilClassName + ' : ' + className + '\n')
		evil.write('+ (void)load\n')
		evil.write('{\n')
#		evil.write('\tprintf("\\n**** %s: ' + evilClassName + ', loading!!\\n", getPidName());\n')
		evil.write('\tprintf("\\n****' + evilClassName + ', loading!!\\n\\n");\n')
		evil.write('\t[self poseAsClass: [%s class]];\n' % (className))
		evil.write('}\n\n')
	elif line.startswith("@end"):
		evil.write("\n@end\n\n")
		evil.flush()
		evil.close()
		className = None
		evilTestFileName = None
		evil = None
	elif line.startswith("- ") or line.startswith("+ "):
		passedSet = []
		passedTypes = {}
		precol = line[:line.find(';')]
		func_name = precol[(precol.find(')')+1):]
		evil.write(precol + "\n{\n")
		
		# decompose
		pat = re.compile("""[+-] \((.*?)\)""")
		return_type = pat.findall(precol)[0]
		args = precol[precol.find(return_type)+len(return_type)+1:]

		# get args
		pat = re.compile('\\s?(.+?):\((.+?)\)([a-zA-Z0-9_]+)')
		args = pat.findall(args)
		
		
		
		
		evil.write('\tNSString *tab = @"";  ')
		evil.write('\tint i = 0;  for (; i < __evilTabCount; i++ ) ')
		evil.write('tab = [tab stringByAppendingString:@"\\t"];\n')
		
		####         NSLog(@"PRE: (void) [Evil %@  unknownPersonCardViewer: %@ dismissPickingOverlay: %@]\n", self, fp8, fp12);
		passedSet.append('tab')
		passedTypes['tab'] = 'id'
		
		if not func_name.startswith('init'):
			evil.write('\tNSLog(@"%@PRE: (' + return_type + ') [Evil %@ ')
			passedSet.append('self')
			passedTypes['self'] = 'id'
		else:
			evil.write('\tNSLog(@"%@PRE: [' + evilClassName + ' ')

		if ( len(args) == 0 ):
			#no args
			evil.write(func_name)
		else:
			for argset in args:
				messageName = argset[0]
				messageParamType = argset[1]
				messageParamName = argset[2]
				passedSet.append(messageParamName)
				passedTypes[messageParamName] = messageParamType

				evil.write(' ' + messageName + ': ')
				writeProperFormatter(messageParamType)
		evil.write(']\\n"')
		writeProperVarsOut(passedSet, passedTypes)		
		evil.write(');  __evilTabCount++;\n')
				
		
		####         [super unknownPersonCardViewer: fp8 dismissPickingOverlay: fp12 ];
		evil.write('\t')
		if return_type != 'void':
			evil.write(return_type + ' supersays = ')
		evil.write('[super ')
		if ( len(args) == 0 ):
			#no args
			evil.write(func_name)
		else:
			for argset in args:
				messageName = argset[0]
				messageParamType = argset[1]
				messageParamName = argset[2]
				evil.write(messageName + ': ' + messageParamName + ' ')
		evil.write('];\n')
		
		
		####		NSLog(@"POST: returning %@', supersays)
		if return_type != 'void':
			evil.write('\tNSLog(@"%@POST: returning ')
			writeProperFormatter(return_type)
			evil.write('", tab')
			writeProperVarsOut(['supersays'], {'supersays': return_type})
			evil.write(');  __evilTabCount--;\n\treturn supersays;\n')
		else:
			evil.write('\tNSLog(@"%@POST: returning void", tab);\n')
			evil.write('\t__evilTabCount--;\n')

		#### }
		evil.write('}\n\n')
