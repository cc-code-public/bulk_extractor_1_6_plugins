#
# make bulk_extractor plugins
# stand

AM_CPPFLAGS =  -I.. -I../src  -I../src/be13_api  -I$(top_srcdir)/src/be13_api

#~ bin_PROGRAMS = plugin_test 

#~ plugin_test_SOURCES = plugin_test.cpp

#EXTRA_DIST = scan_demo.cpp scan_flexdemo.flex be13_api dfxml
EXTRA_DIST = be13_api dfxml scan_bitcoin.flex scan_monero.flex scan_mnemonics.flex scan_domains.flex scan_hwallets.flex

# lib_LTLIBRARIES = scan_demo.so scan_flexdemo.so

#plugins:
#	$(MAKE) scan_demo.so scan_flexdemo.so
#	@echo "Available Plugins:"
#	ls -l *.so

plugins:
	$(MAKE) scan_bitcoin.so scan_monero.so scan_mnemonics.so scan_domains.so scan_hwallets.so
	@echo "Available Plugins:"
	ls -l *.so

# scan_demo_so_SOURCES = scan_demo.cpp
# scan_demo_dll_SOURCES = scan_demo.cpp
# scan_flexdemo_so_SOURCES = scan_flexdemo.cpp
# scan_flexdemo_dll_SOURCES = scan_flexdemo.cpp

#scan_demo.so: scan_demo.cpp
#scan_flexdemo.so: scan_flexdemo.flex

#scan_demo.dll: scan_demo.cpp
#scan_flexdemo.dll: scan_flexdemo.flex

scan_bitcoin.so: scan_bitcoin.flex
scan_bitcoin.dll: scan_bitcoin.flex

scan_monero.so: scan_monero.flex
scan_monero.dll: scan_monero.flex

scan_mnemonics.so: scan_mnemonics.flex
scan_mnemonics.dll: scan_mnemonics.flex

scan_domains.so: scan_domains.flex
scan_domains.dll: scan_domains.flex

scan_hwallets.so: scan_hwallets.flex
scan_hwallets.dll: scan_hwallets.flex

#
# Rule to compile .flex into a .o
# 
# Note: Not clear if we should be using $(CXX) or $(CXXCOMPILE) below

#CLEANFILES=scan_demo.d scan_demo.o scan_demo.so \
#	sscan_flexdemo.d can_flexdemo.cpp scan_flexdemo.o scan_flexdemo.so 

CLEANFILES=scan_bitcoin.d scan_bitcoin.o scan_bitcoin.so  scan_monero.d scan_monero.o scan_monero.so scan_mnemonics.d scan_mnemonics.o scan_mnemonics.so scan_domains.d scan_domains.o scan_domains.so scan_hwallets.d scan_hwallets.o scan_hwallets.so

SUFFIXES = .so .flex
.cpp.so:
	$(CXX) -shared -fPIC -o $@ $(CXXFLAGS) $(AM_CPPFLAGS) $<

FLEX_CXXFLAGS=-Wno-shadow -Wno-effc++ -Wno-redundant-decls -Wno-missing-noreturn
.flex.so:
	flex -o `basename $@ .so`.cpp $<  
	$(CXX) $(FLEX_CXXFLAGS) -shared -fPIC $(CXXFLAGS) $(AM_CPPFLAGS) -o $@ `basename $@ .so`.cpp 

