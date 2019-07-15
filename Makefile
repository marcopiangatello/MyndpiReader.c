CC=gcc
CXX=g++
CFLAGS=-g -I../src/include -g -O2
LIBNDPI=../src/lib/libndpi.a
LDFLAGS=$(LIBNDPI) -lpcap -lpthread 
OBJS=ndpiReader.o ndpi_util.o
PREFIX?=/usr/local

all: ndpiReader 

ndpiReader: $(OBJS) $(LIBNDPI)
	$(CXX) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS)

%.o: %.c $(HEADERS) Makefile
	$(CC) $(CFLAGS) -c $< -o $@

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	cp ndpiReader $(DESTDIR)$(PREFIX)/bin/
	[ -f build/app/ndpiReader.dpdk ] && cp build/app/ndpiReader.dpdk $(DESTDIR)$(PREFIX)/bin/ || true
	[ -f ndpiReader.dpdk ] && cp ndpiReader.dpdk $(DESTDIR)$(PREFIX)/bin/ || true

dpdk:
	make -f Makefile.dpdk

check:
	 cppcheck --template='{file}:{line}:{severity}:{message}' --quiet --enable=all --force -I../src/include  -I/usr/local/include/json-c  *.c

clean:
	/bin/rm -f *.o ndpiReader ndpiReader.dpdk
	/bin/rm -f .*.dpdk.cmd .*.o.cmd *.dpdk.map .*.o.d
	/bin/rm -f _install _postbuild _postinstall _preinstall
	/bin/rm -rf build

distclean: clean
	/bin/rm -f Makefile.dpdk
	/bin/rm -f Makefile
