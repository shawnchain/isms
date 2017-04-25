/opt/iphone/bin/arm-apple-darwin-gcc -c -Wall -DNDEBUG -DDEBUG -DDEBUG_HOOK_INSTALL -DSTANDALONE  -g -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char SBHookInstaller.m -c -o SBHookInstaller.o

/opt/iphone/bin/arm-apple-darwin-gcc -c -Wall -DNDEBUG -DDEBUG -DDEBUG_HOOK_INSTALL -DSTANDALONE -g -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char ../common/Logger.m -c -o Logger.o

/opt/iphone/bin/arm-apple-darwin-gcc  -Wall -DNDEBUG -DDEBUG -DDEBUG_HOOK_INSTALL -DSTANDALONE  -g -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char -framework Foundation -framework CoreFoundation -lobjc Logger.o SBHookInstaller.m  -o SBHookInstaller.debug

rm -f *.o
