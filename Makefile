CXX=g++
CXXFLAGS=-Wall -Wextra -std=c++14 -fno-omit-frame-pointer -fsigned-char -Wsign-compare -Wno-unused-parameter -Werror -O3 -flto -DLINUX
INCLUDES=-I/usr/include/freetype2 -I/usr/include/libpng16
LDFLAGS=-lXmu -lXt -lX11 -lfreetype -lEGL -lGLESv2 -lpthread

SOURCES = src/main.cc src/fontpack.cc src/charvdev.cc src/log.cc src/font.cc src/renderer.cc src/frame.cc src/vterm.cc src/options.cc src/selmgr.cc src/gl.cc src/pty.cc

all:
	$(CXX) $(SOURCES) $(CXXFLAGS) $(INCLUDES) -o bin/tty $(LDFLAGS)
