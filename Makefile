# Makefile for gcc compiler for iPhone

PROJECTNAME=opengl
APPFOLDER=$(PROJECTNAME).app
INSTALLFOLDER=$(PROJECTNAME).app
SDKDIR=/

CC=arm-apple-darwin9-gcc
CPP=arm-apple-darwin9-g++
LD=$(CC)

LDFLAGS = -isysroot $(SDKDIR)
LDFLAGS += -L"$(SDKDIR)/usr/lib"
LDFLAGS += -F"$(SDKDIR)/System/Library/Frameworks"
LDFLAGS += -F"$(SDKDIR)/System/Library/PrivateFrameworks"
LDFLAGS += -arch arm -lobjc -lstdc++
LDFLAGS += -framework CoreFoundation 
LDFLAGS += -framework Foundation 
LDFLAGS += -framework UIKit 
LDFLAGS += -framework QuartzCore
LDFLAGS += -framework CoreGraphics 
LDFLAGS += -framework GraphicsServices 
LDFLAGS += -framework OpenGLES
LDFLAGS += -framework CoreSurface 
//LDFLAGS += -framework CoreAudio 
//LDFLAGS += -framework Celestial 
//LDFLAGS += -framework AudioToolbox 
//LDFLAGS += -framework WebCore
//LDFLAGS += -framework WebKit
LDFLAGS += -bind_at_load
LDFLAGS += -multiply_defined suppress
#LDFLAGS += -march=armv6
#LDFLAGS += -mcpu=arm1176jzf-s 

CFLAGS = -isysroot $(SDKDIR)
CFLAGS += -I"$(SDKDIR)/usr/include" 
#CFLAGS += -I"/var/include" 
#CFLAGS += -DDEBUG -O3 -Wall -std=c99 -funroll-loops 
CFLAGS += -DDEBUG -Wall -std=c99 

CPPFLAGS = -isysroot $(SDKDIR)
CPPFLAGS += -I"$(SDKDIR)/usr/include" 

BUILDDIR=./build
SRCDIR=./Classes
RESDIR=./Resources
OBJS=$(patsubst %.m,%.o,$(wildcard $(SRCDIR)/*.m))
OBJS+=$(patsubst %.c,%.o,$(wildcard $(SRCDIR)/*.c))
OBJS+=$(patsubst %.cpp,%.o,$(wildcard $(SRCDIR)/*.cpp))
RESOURCES=$(wildcard $(RESDIR)/*)


all:	dist

$(PROJECTNAME): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o:	%.m
	$(CC) -c $(CFLAGS) $< -o $@

%.o:	%.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o:	%.cpp
	$(CPP) -c $(CPPFLAGS) $< -o $@

dist:	$(PROJECTNAME)
	/bin/rm -rf $(BUILDDIR)
	/bin/mkdir -p $(BUILDDIR)/$(APPFOLDER)
	/bin/cp $(RESDIR)/* $(BUILDDIR)/$(APPFOLDER)
	/bin/cp Info.plist $(BUILDDIR)/$(APPFOLDER)/Info.plist
	@echo "APPL????" > $(BUILDDIR)/$(APPFOLDER)/PkgInfo
	/usr/bin/ldid -S $(PROJECTNAME)
	/bin/cp $(PROJECTNAME) $(BUILDDIR)/$(APPFOLDER)

install: dist
	/bin/cp -r $(BUILDDIR)/$(APPFOLDER) /Applications/$(INSTALLFOLDER)
	@echo "Application $(INSTALLFOLDER) installed"
	killall -HUP SpringBoard

uninstall:
	/bin/rm -fr /Applications/$(INSTALLFOLDER)
	killall -HUP SpringBoard

reinstall: dist
	/bin/rm -fr /Applications/$(INSTALLFOLDER)
	/bin/cp -r $(BUILDDIR)/$(APPFOLDER) /Applications/$(INSTALLFOLDER)
	@echo "Application $(INSTALLFOLDER) installed"

clean:
	@rm -f $(SRCDIR)/*.o
	@rm -rf $(BUILDDIR)
	@rm -f $(PROJECTNAME)
