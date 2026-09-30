# Copyright 2026 Aaron Nixon
# Distributed under the terms of the MIT license

EAPI=8

inherit cmake

DESCRIPTION="Emacs-class terminal text editor, Janet-scriptable, Notcurses UI"
HOMEPAGE="https://github.com/SuperFes/ned"
SRC_URI="https://github.com/SuperFes/ned/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	llvm-core/clang
	llvm-core/lld
"

RDEPEND="
	dev-lang/janet
    dev-libs/libutf8proc
    dev-libs/re2
    dev-libs/libpcre2
    dev-cpp/cli11
    dev-cpp/nlohmann_json
	dev-libs/libunistring
	app-arch/libdeflate
	>=dev-cpp/notcurses-3.0.17
	test? ( dev-cpp/catch )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++
		-DCMAKE_LINKER_TYPE=LLD
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DNED_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
