//===-- POSIX header <nl_types.h> --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===---------------------------------------------------------------------===//

#ifndef _LLVM_LIBC_NL_TYPES_H
#define _LLVM_LIBC_NL_TYPES_H

#include "__llvm-libc-common.h"
#include "llvm-libc-macros/nl-types-macros.h"
#include "llvm-libc-types/nl_catd.h"

__BEGIN_C_DECLS

int catclose(nl_catd) __NOEXCEPT;

char *catgets(nl_catd, int, int, const char*) __NOEXCEPT;

nl_catd catopen(const char *, int) __NOEXCEPT;

__END_C_DECLS

#endif // _LLVM_LIBC_NL_TYPES_H
