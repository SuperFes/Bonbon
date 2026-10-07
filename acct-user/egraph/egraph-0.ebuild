# Copyright 2026 Aaron Nixon
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for egraphd, which keeps egraph's stores fresh"
ACCT_USER_ID=-1
ACCT_USER_HOME="/var/cache/egraph"
# portage: the preserved-libs registry is readable only by root and portage.
ACCT_USER_GROUPS=( egraph portage )

acct-user_add_deps
