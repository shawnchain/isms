/opt/iphone/bin/arm-apple-darwin-gcc -c -Wall -O3 -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char -DNDEBUG   -DSTANDALONE SBHookInstaller.m -c -o SBHookInstaller.o

/opt/iphone/bin/arm-apple-darwin-gcc -c -Wall -O3 -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char -DNDEBUG  ../common/Logger.m -c -o Logger.o

/opt/iphone/bin/arm-apple-darwin-gcc -isysroot /opt/iphone/heavenly/1.0.2/system -isystem /opt/iphone/include -isystem /opt/iphone/include/gcc/darwin/3.3 -isystem /opt/iphone/heavenly/1.0.2/include -std=gnu99 -fsigned-char -framework Foundation -framework CoreFoundation -lobjc -DSTANDALONE Logger.o SBHookInstaller.m  -o SBHookInstaller

rm -f *.o
