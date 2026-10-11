# Copyright 2026 Aaron Nixon
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit meson python-single-r1 systemd

DESCRIPTION="A persistent dependency graph of a Gentoo system, queryable in milliseconds"
HOMEPAGE="https://github.com/SuperFes/egraph"
SRC_URI="https://github.com/SuperFes/egraph/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+notify systemd test +tui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'sys-apps/portage[${PYTHON_USEDEP}]')
	acct-user/egraph
	notify? ( || ( sys-apps/systemd sys-auth/elogind ) )
	systemd? ( sys-apps/systemd:= )
	tui? ( >=dev-cpp/notcurses-3 )
"
# The build always configures the unit tests, so Catch2 is needed whether or not they run.
DEPEND="
	${RDEPEND}
	>=dev-cpp/catch-3.4:0
	>=dev-cpp/cli11-2.4
	>=dev-cpp/nlohmann_json-3.10
"
BDEPEND="
	test? ( $(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]') )
"

src_configure() {
	local emesonargs=(
		$(meson_feature notify)
		$(meson_feature systemd journal)
		$(meson_feature tui)
		-Dportage_hooks=true
		-Dportage_config="${EPREFIX}/etc/portage"
		-Dsystemd_unit_dir="$(systemd_get_systemunitdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/egraph-build
	python_optimize
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/etc/portage/bin/post_emerge ]]; then
		elog "Syncs refresh egraph's store through /etc/portage/postsync.d. For emerges to refresh"
		elog "it too, link the dispatcher for /etc/portage/post_emerge.d where portage runs it:"
		elog "  ln -s ${EPREFIX}/usr/share/egraph/post_emerge ${EPREFIX}/etc/portage/bin/post_emerge"
	else
		elog "${EPREFIX}/etc/portage/bin/post_emerge exists, so egraph's hook in post_emerge.d runs"
		elog "only if it calls ${EPREFIX}/usr/share/egraph/post_emerge (or runs post_emerge.d itself)."
	fi
	elog "Build the system store once as root: egraph rebuild"
	elog "To keep the stores fresh as the system changes, start egraphd:"
	elog "  systemctl enable --now egraphd   (systemd)"
	elog "  rc-update add egraphd default    (OpenRC)"
	if use notify; then
		elog "egraph notify starts with each desktop session, through ${EPREFIX}/etc/xdg/autostart."
	fi
}
