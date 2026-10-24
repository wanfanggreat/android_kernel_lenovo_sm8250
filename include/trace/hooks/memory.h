/* SPDX-License-Identifier: GPL-2.0 */
/*
 * p11 K1 port: no-op stubs for the ANDROID_VENDOR_HOOKS tracepoints used by
 * the BPF uplift files. The Lenovo 4.19 kernel does not carry the android
 * vendor hook infrastructure; these expand to nothing. Keep the ported
 * .c files byte-identical to the LineageOS xiaomi sm8250 source so later
 * re-syncs stay trivial.
 */
#ifndef _TRACE_HOOK_MEMORY_STUB_H
#define _TRACE_HOOK_MEMORY_STUB_H

#define trace_android_vh_set_memory_x(addr, nr_pages)  do { } while (0)
#define trace_android_vh_set_memory_nx(addr, nr_pages) do { } while (0)
#define trace_android_vh_set_memory_ro(addr, nr_pages) do { } while (0)
#define trace_android_vh_set_memory_rw(addr, nr_pages) do { } while (0)

#endif /* _TRACE_HOOK_MEMORY_STUB_H */
