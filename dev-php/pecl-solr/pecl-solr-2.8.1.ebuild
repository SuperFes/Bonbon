# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_PHP="php5-6 php7-0 php7-1 php8-2 php8-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Communicate easily and efficiently with Apache Solr server instances"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/libxml2
	net-misc/curl
	php_targets_php5-6? ( dev-lang/php:5.6[json] )
	php_targets_php7-0? ( dev-lang/php:7.0[json] )
	php_targets_php7-1? ( dev-lang/php:7.1[json] )
	php_targets_php8-2? ( dev-lang/php:8.2 )
	php_targets_php8-4? ( dev-lang/php:8.4 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=( )
	php-ext-source-r3_src_configure
}
