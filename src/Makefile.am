
AM_CPPFLAGS = -I/usr/include/gc
bin_PROGRAMS = onyx onyx-boot

onyx_SOURCES = interp.c new_memory.c main.c
onyx_LDADD = -lgc
onyx_boot_SOURCES = imageBuilder.c

data_DATA = systemImage

CLEANFILES = systemImage

systemImage: onyx-boot imageSource
	./onyx-boot imageSource
	mv image systemImage
