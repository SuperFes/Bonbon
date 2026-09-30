EAPI=8

inherit cmake

KV="6.1.breeze6.0.3"

NAME="Klassy"
DESCRIPTION="Klassy is a highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop."
HOMEPAGE="https://github.com/paulmcauley/klassy/"
SRC_URI="https://github.com/paulmcauley/${PN}/archive/refs/tags/${KV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${KV}"

LICENSE="GPL-2 GPL-3 MIT"

SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-6.6
	dev-build/cmake
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-disable-kf5.patch
)

src_configure() {
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
