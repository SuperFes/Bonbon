# Copyright 2026 Aaron Nixon
# Distributed under the terms of the MIT license

EAPI=8

inherit cmake

DESCRIPTION="Emacs-class terminal text editor, Janet-scriptable, Notcurses UI"
HOMEPAGE="https://github.com/SuperFes/ned"

# One entry per FetchContent_Declare/ned_add_treesitter_grammar call in
# CMakeLists.txt, "<FetchContent content name>:<downloaded tarball name>".
# The content name must match CMakeLists.txt's own declared name exactly
# (case included -- it's uppercased verbatim, hyphens kept, to build each
# FETCHCONTENT_SOURCE_DIR_<NAME> override in src_configure below). Keep
# this table AND SRC_URI in sync by hand with CMakeLists.txt -- a version
# bump there needs the matching tag updated in both places here too.
# tree-sitter-markdown-inline deliberately reuses tree-sitter-markdown's
# own tarball: same upstream repo, two grammars in two subdirectories.
NED_DEPS=(
	"notcurses:ned-notcurses-3.0.14.tar.gz"
	"utf8proc:ned-utf8proc-2.9.0.tar.gz"
	"CLI11:ned-cli11-2.5.0.tar.gz"
	"nlohmann_json:ned-nlohmann-json-3.12.0.tar.gz"
	"tree-sitter:ned-tree-sitter-0.25.10.tar.gz"
	"libvterm:ned-libvterm-0.3.3.tar.gz"
	"tree-sitter-json:ned-ts-json-0.24.8.tar.gz"
	"tree-sitter-c:ned-ts-c-0.24.2.tar.gz"
	"tree-sitter-cpp:ned-ts-cpp-0.23.4.tar.gz"
	"tree-sitter-php:ned-ts-php-0.24.2.tar.gz"
	"tree-sitter-javascript:ned-ts-javascript-0.25.0.tar.gz"
	"tree-sitter-typescript-src:ned-ts-typescript-0.23.2.tar.gz"
	"tree-sitter-html:ned-ts-html-0.23.2.tar.gz"
	"tree-sitter-css:ned-ts-css-0.25.0.tar.gz"
	"tree-sitter-python:ned-ts-python-0.25.0.tar.gz"
	"tree-sitter-bash:ned-ts-bash-0.25.1.tar.gz"
	"tree-sitter-janet-simple:ned-ts-janet-simple-0.0.7.tar.gz"
	"tree-sitter-markdown:ned-ts-markdown-0.5.3.tar.gz"
	"tree-sitter-markdown-inline:ned-ts-markdown-0.5.3.tar.gz"
	"tree-sitter-yaml:ned-ts-yaml-0.7.2.tar.gz"
	"tree-sitter-toml:ned-ts-toml-0.7.0.tar.gz"
	"tree-sitter-clojure:ned-ts-clojure-0.0.13.tar.gz"
	# Forked "org" grammar (github.com/SuperFes/tree-sitter-ned-org, itself
	# forked from nvim-orgmode/tree-sitter-org) -- pinned to a commit, not a
	# tag, so it needs the raw-SHA archive URL form in SRC_URI below.
	"tree-sitter-org:ned-ts-org-05b4c75.tar.gz"
)

SRC_URI="
	https://github.com/SuperFes/ned/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/SuperFes/tree-sitter-ned-org/archive/05b4c7505c452f42330c681a067842d4cb49b174.tar.gz -> ned-ts-org-05b4c75.tar.gz
	https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.14.tar.gz -> ned-notcurses-3.0.14.tar.gz
	https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.9.0.tar.gz -> ned-utf8proc-2.9.0.tar.gz
	https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.5.0.tar.gz -> ned-cli11-2.5.0.tar.gz
	https://github.com/nlohmann/json/archive/refs/tags/v3.12.0.tar.gz -> ned-nlohmann-json-3.12.0.tar.gz
	https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.10.tar.gz -> ned-tree-sitter-0.25.10.tar.gz
	https://github.com/neovim/libvterm/archive/refs/tags/v0.3.3.tar.gz -> ned-libvterm-0.3.3.tar.gz
	https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz -> ned-ts-json-0.24.8.tar.gz
	https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.24.2.tar.gz -> ned-ts-c-0.24.2.tar.gz
	https://github.com/tree-sitter/tree-sitter-cpp/archive/refs/tags/v0.23.4.tar.gz -> ned-ts-cpp-0.23.4.tar.gz
	https://github.com/tree-sitter/tree-sitter-php/archive/refs/tags/v0.24.2.tar.gz -> ned-ts-php-0.24.2.tar.gz
	https://github.com/tree-sitter/tree-sitter-javascript/archive/refs/tags/v0.25.0.tar.gz -> ned-ts-javascript-0.25.0.tar.gz
	https://github.com/tree-sitter/tree-sitter-typescript/archive/refs/tags/v0.23.2.tar.gz -> ned-ts-typescript-0.23.2.tar.gz
	https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz -> ned-ts-html-0.23.2.tar.gz
	https://github.com/tree-sitter/tree-sitter-css/archive/refs/tags/v0.25.0.tar.gz -> ned-ts-css-0.25.0.tar.gz
	https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v0.25.0.tar.gz -> ned-ts-python-0.25.0.tar.gz
	https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v0.25.1.tar.gz -> ned-ts-bash-0.25.1.tar.gz
	https://github.com/sogaiu/tree-sitter-janet-simple/archive/refs/tags/v0.0.7.tar.gz -> ned-ts-janet-simple-0.0.7.tar.gz
	https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.3.tar.gz -> ned-ts-markdown-0.5.3.tar.gz
	https://github.com/tree-sitter-grammars/tree-sitter-yaml/archive/refs/tags/v0.7.2.tar.gz -> ned-ts-yaml-0.7.2.tar.gz
	https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz -> ned-ts-toml-0.7.0.tar.gz
	https://github.com/sogaiu/tree-sitter-clojure/archive/refs/tags/v0.0.13.tar.gz -> ned-ts-clojure-0.0.13.tar.gz
	test? ( https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.tar.gz -> ned-catch2-3.7.1.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# CMakePresets.json's own "default" preset (this project's documented build
# entry point) pins Clang+LLD explicitly, not just "whatever the system
# default happens to be" -- matched here rather than risking an untested
# GCC build.
BDEPEND="
	llvm-core/clang
	llvm-core/lld
"

# Runtime libraries actually observed via `ldd`/`readelf` against a real
# build, not assumed: janet (pkg_check_modules(Janet REQUIRED janet) in
# CMakeLists.txt), and notcurses-core's own transitive shared-library deps
# (terminfo, unistring, deflate) -- notcurses-core itself is bundled
# privately by ned's own install() rules (see CMakeLists.txt's packaging
# follow-up comments), not linked against any system notcurses package.
# Everything else FetchContent pulls in (utf8proc, libvterm, tree-sitter
# core + every grammar, CLI11, nlohmann_json) links fully static into
# ned_lib -- confirmed via ldd showing no corresponding .so at all.
RDEPEND="
	dev-lang/janet
	sys-libs/ncurses:=
	dev-libs/libunistring
	app-arch/libdeflate
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_unpack() {
	# ned's own source and every FetchContent dependency (including the
	# forked org grammar, now a normal GitHub archive URL like everything
	# else): portage already fetched all of these via SRC_URI in its own
	# always-network-allowed fetch phase. Unpacked here with a controlled
	# destination name (--strip-components=1, so GitHub's own
	# archive-directory-naming convention never matters) so
	# src_configure's FETCHCONTENT_SOURCE_DIR_<NAME> overrides can point
	# straight at them. ned's own tarball extracts directly into ${S}.
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/${P}.tar.gz" --strip-components=1 -C "${S}" \
		|| die "failed to unpack ${P}.tar.gz"

	local entry name tarball
	for entry in "${NED_DEPS[@]}"; do
		name="${entry%%:*}"
		tarball="${entry#*:}"
		mkdir -p "${WORKDIR}/${name}" || die
		tar -xf "${DISTDIR}/${tarball}" --strip-components=1 -C "${WORKDIR}/${name}" \
			|| die "failed to unpack ${tarball}"
	done

	if use test; then
		mkdir -p "${WORKDIR}/Catch2" || die
		tar -xf "${DISTDIR}/ned-catch2-3.7.1.tar.gz" --strip-components=1 -C "${WORKDIR}/Catch2" \
			|| die "failed to unpack ned-catch2-3.7.1.tar.gz"
	fi
}

src_prepare() {
	cmake_src_prepare

	# FETCHCONTENT_SOURCE_DIR_NOTCURSES (set in src_configure) makes
	# FetchContent skip notcurses' own declared PATCH_COMMAND entirely --
	# CMake's documented behavior for an overridden source dir, confirmed
	# against this exact project during the packaging follow-up: a plain
	# FETCHCONTENT_SOURCE_DIR override silently drops PATCH_COMMAND/
	# UPDATE_COMMAND both. Applied by hand here instead, using the exact
	# same checked-in, idempotent script CMakeLists.txt would otherwise run
	# (its own cwd-is-the-source-tree contract, see the script's own header
	# comment) -- single source of truth for what the patch actually does.
	( cd "${WORKDIR}/notcurses" && cmake -P "${S}/CMake/PatchNotcursesNulKey.cmake" ) \
		|| die "failed to apply notcurses NUL-key patch"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++
		-DCMAKE_LINKER_TYPE=LLD
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DNED_BUILD_TESTS=$(usex test)
	)

	local entry name
	for entry in "${NED_DEPS[@]}"; do
		name="${entry%%:*}"
		mycmakeargs+=( "-DFETCHCONTENT_SOURCE_DIR_${name^^}=${WORKDIR}/${name}" )
	done

	if use test; then
		mycmakeargs+=( "-DFETCHCONTENT_SOURCE_DIR_CATCH2=${WORKDIR}/Catch2" )
	fi

	cmake_src_configure
}
