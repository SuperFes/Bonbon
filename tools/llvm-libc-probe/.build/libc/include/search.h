//===-- POSIX header <search.h> --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===---------------------------------------------------------------------===//

#ifndef _LLVM_LIBC_SEARCH_H
#define _LLVM_LIBC_SEARCH_H

#include "__llvm-libc-common.h"
#include "llvm-libc-types/ACTION.h"
#include "llvm-libc-types/ENTRY.h"
#include "llvm-libc-types/VISIT.h"
#include "llvm-libc-types/__search_compare_t.h"
#include "llvm-libc-types/size_t.h"
#include "llvm-libc-types/struct_hsearch_data.h"

__BEGIN_C_DECLS

int hcreate(size_t) __NOEXCEPT;

int hcreate_r(size_t, struct hsearch_data *) __NOEXCEPT;

void hdestroy(void) __NOEXCEPT;

void hdestroy_r(struct hsearch_data *) __NOEXCEPT;

ENTRY *hsearch(ENTRY, ACTION) __NOEXCEPT;

int hsearch_r(ENTRY, ACTION, ENTRY * *, struct hsearch_data *) __NOEXCEPT;

void insque(void *, void *) __NOEXCEPT;

void *lfind(const void *, const void *, size_t *, size_t, __search_compare_t) __NOEXCEPT;

void *lsearch(const void *, void *, size_t *, size_t, __search_compare_t) __NOEXCEPT;

void remque(void *) __NOEXCEPT;

__END_C_DECLS

#endif // _LLVM_LIBC_SEARCH_H
