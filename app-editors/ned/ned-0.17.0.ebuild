# Copyright 2026 Aaron Nixon
# Distributed under the terms of the MIT license

EAPI=8

ZIG_SLOT="0.15"
ZIG_NEEDS_LLVM=1
ZIG_OPTIONAL=1

inherit cmake zig-utils

DESCRIPTION="Emacs-class terminal text editor, Janet-scriptable, Notcurses UI"
HOMEPAGE="https://github.com/SuperFes/ned"

# The static ned-agent deployed to remote hosts links these from source,
# pinned in CMake/StaticAgent.cmake.
ABSL_PV="20260107.1"
RE2_PV="2025-08-12"
ZSTD_PV="1.5.7"
JSON_PV="3.12.0"

SRC_URI="
	https://github.com/SuperFes/ned/archive/refs/tags/v${PV}.tar.gz
	remote? (
		https://github.com/abseil/abseil-cpp/archive/${ABSL_PV}.tar.gz -> abseil-cpp-${ABSL_PV}.tar.gz
		https://github.com/google/re2/releases/download/${RE2_PV}/re2-${RE2_PV}.tar.gz
		https://github.com/facebook/zstd/releases/download/v${ZSTD_PV}/zstd-${ZSTD_PV}.tar.gz
		https://github.com/nlohmann/json/archive/v${JSON_PV}.tar.gz -> nlohmann-json-${JSON_PV}.tar.gz
	)
"

LICENSE="MIT remote? ( Apache-2.0 BSD || ( BSD GPL-2 ) MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+remote test"
RESTRICT="!test? ( test )"

NED_AGENT_ARCHES=( x86_64 aarch64 )

BDEPEND="
	llvm-core/clang
	llvm-core/lld
	remote? (
		|| (
			dev-lang/zig:${ZIG_SLOT}[llvm(+)]
			dev-lang/zig-bin:${ZIG_SLOT}
		)
	)
"

RDEPEND="
	sys-apps/file
	dev-lang/janet
	dev-libs/libutf8proc
	dev-libs/re2
	dev-libs/libpcre2
	dev-libs/libvterm
	dev-cpp/cli11
	dev-cpp/nlohmann_json
	dev-libs/libunistring
	app-arch/libdeflate
	app-arch/zstd
	media-libs/libpng
	media-libs/libjpeg-turbo
	media-libs/libwebp
	>=dev-cpp/notcurses-3.0.17
	test? ( dev-cpp/catch )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

# Static, stripped, and one of them for another architecture: they're
# copied to remote hosts, never run here.
QA_FLAGS_IGNORED="usr/libexec/ned/agent/.*/ned-agent"

pkg_setup() {
	use remote && zig-utils_setup
}

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

	use remote || return

	# zig brings its own clang, musl and libc++; the host's flags target
	# neither it nor aarch64.
	local arch
	for arch in "${NED_AGENT_ARCHES[@]}"; do
		env -u CFLAGS -u CXXFLAGS -u LDFLAGS -u CPPFLAGS -u CC -u CXX \
			cmake -S "${S}" -B "${WORKDIR}/agent-${arch}" -G Ninja \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr" \
			-DCMAKE_TOOLCHAIN_FILE="${S}/CMake/Toolchains/ZigMusl.cmake" \
			-DNED_AGENT_ONLY=ON \
			-DNED_AGENT_ARCH="${arch}" \
			-DNED_ZIG="${ZIG_EXE}" \
			-DFETCHCONTENT_FULLY_DISCONNECTED=ON \
			-DFETCHCONTENT_SOURCE_DIR_ABSL="${WORKDIR}/abseil-cpp-${ABSL_PV}" \
			-DFETCHCONTENT_SOURCE_DIR_RE2="${WORKDIR}/re2-${RE2_PV}" \
			-DFETCHCONTENT_SOURCE_DIR_ZSTD="${WORKDIR}/zstd-${ZSTD_PV}" \
			-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON="${WORKDIR}/json-${JSON_PV}" \
			|| die "configuring the ${arch} agent failed"
	done
}

src_compile() {
	cmake_src_compile

	use remote || return

	export ZIG_GLOBAL_CACHE_DIR="${T}/zig-cache" ZIG_LOCAL_CACHE_DIR="${T}/zig-cache"
	local arch
	for arch in "${NED_AGENT_ARCHES[@]}"; do
		eninja -C "${WORKDIR}/agent-${arch}" ned-agent
	done
}

src_install() {
	cmake_src_install

	use remote || return

	local arch
	for arch in "${NED_AGENT_ARCHES[@]}"; do
		DESTDIR="${D}" cmake --install "${WORKDIR}/agent-${arch}" --component agent \
			|| die "installing the ${arch} agent failed"
	done
	dostrip -x /usr/libexec/ned/agent
}
