/* SPDX-License-Identifier: GPL-2.0 */
/* p11 K1 port: no-op stub, see include/trace/hooks/memory.h */
#ifndef _TRACE_HOOK_SYSCALL_CHECK_STUB_H
#define _TRACE_HOOK_SYSCALL_CHECK_STUB_H

union bpf_attr;
struct bpf_attr_fixup;

#define trace_android_vh_check_bpf_syscall(cmd, attr, size) do { } while (0)

#endif /* _TRACE_HOOK_SYSCALL_CHECK_STUB_H */
