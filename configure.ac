#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(onyx, [0.0.1], [sam@dasbistro.com])
AM_INIT_AUTOMAKE(onyx, [0.0.1])
AC_CONFIG_SRCDIR([config.h.in])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.

## Modify CFLAGS to disable optimizations
if test -n "${CFLAGS}"; then
  user_set_cxxflags=yes
fi
AC_PROG_CC
if test X$user_set_cxxflags != Xyes; then
  CFLAGS="-g"
fi

# Checks for libraries.

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([fcntl.h limits.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([bzero strdup])

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 doc/Makefile])
AC_OUTPUT
