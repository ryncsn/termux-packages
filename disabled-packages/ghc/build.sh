# See https://ghc.haskell.org/trac/ghc/wiki/Building/CrossCompiling
#     https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux
# and
#     https://github.com/neurocyte/ghc-android
TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compilation system"
TERMUX_PKG_VERSION=8.4.3
TERMUX_PKG_SRCURL=file:///home/builder/termux-packages/disabled-packages/ghc/ghc-src.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
# Depend on clang for now until llvm is split into separate package:
TERMUX_PKG_DEPENDS="clang, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-iconv-includes=$TERMUX_PREFIX/include --with-iconv-libraries=$TERMUX_PREFIX/lib --with-curses-includes=$TERMUX_PREFIX/include/ncursesw --with-curses-libraries=$TERMUX_PREFIX/lib --host=x86_64-unknown-linux --build=x86_64-unknown-linux --target=${TERMUX_HOST_PLATFORM}
"

termux_step_post_extract_package() {
    echo "Ready"
}

termux_step_pre_configure () {
	#echo "GhcStage2HcOpts = $ORIG_CFLAGS $ORIG_CPPFLAGS $ORIG_LDFLAGS" >> mk/build.mk

#	# Avoid "Can't use -fPIC or -dynamic on this platform":
#	echo "GhcLibWays = v" >> mk/build.mk
	# "Can not build haddock docs when CrossCompiling or Stage1Only".

    # export CFLAGS="$CFLAGS -std=gnu99"
    # export CXXFLAGS="$CPPFLAGS -std=c++11"

	echo "DYNAMIC_GHC_PROGRAMS = NO" >> mk/build.mk
	echo "INTEGER_LIBRARY = integer-simple" > mk/build.mk
	echo "BuildFlavour = perf-cross" > mk/build.mk
	echo "HADDOCK_DOCS = NO" >> mk/build.mk
    echo "BUILD_SPHINX_HTML = NO" >> mk/build.mk
    echo "BUILD_SPHINX_PDF = NO" >> mk/build.mk
    echo "GhcLibHcOpts += -fPIC" >> mk/build.mk
    echo "GhcRtsHcOpts += -fPIC" >> mk/build.mk
    echo "EXTRA_CC_OPTS += -std=c99" >> mk/build.mk

    ./boot
}
