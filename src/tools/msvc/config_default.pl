
# Copyright (c) 2021-2022, PostgreSQL Global Development Group

# Configuration arguments for vcbuild.
use strict;
use warnings;

our $config = {
	asserts => 0,    # --enable-cassert

	# blocksize => 8,         # --with-blocksize, 8kB by default
	# wal_blocksize => 8,     # --with-wal-blocksize, 8kB by default
	ldap      => 1,        # --with-ldap
	extraver  => undef,    # --with-extra-version=<string>
	gss       => undef,    # --with-gssapi=<path>
	icu       => "$ENV{PGWIN_DEPS_DIR}/icu",    # --with-icu=<path>
	lz4       => "$ENV{PGWIN_DEPS_DIR}/lz4",    # --with-lz4=<path>
	zstd      => "$ENV{PGWIN_DEPS_DIR}/zstd",    # --with-zstd=<path>
	nls       => undef,    # --enable-nls=<path>
	tap_tests => 1,    # --enable-tap-tests
	tcl       => undef,    # --with-tcl=<path>
	perl      => undef,    # --with-perl=<path>
	python    => undef,    # --with-python=<path>
	openssl   => "$ENV{PGWIN_DEPS_DIR}/openssl",    # --with-ssl=openssl with <path>
	uuid      => "$ENV{PGWIN_DEPS_DIR}/uuid",    # --with-uuid=<path>
	xml       => "$ENV{PGWIN_DEPS_DIR}/xml",    # --with-libxml=<path>
	xslt      => "$ENV{PGWIN_DEPS_DIR}/xslt",    # --with-libxslt=<path>
	iconv     => undef,    # (not in configure, path to iconv)
	zlib      => "$ENV{PGWIN_DEPS_DIR}/zlib"     # --with-zlib=<path>
};

1;
