// BionicSX2 — iOS Host System Memory Management
// Phase 2 implementation target
// Reference: Darwin XNU vm_allocate / vm_protect
// NO stubs — every function below has a concrete implementation plan

#include <mach/mach.h>
#include <mach/vm_map.h>
#include <pthread.h>
#include <sys/mman.h>

// TODO Phase 2: Implement using vm_allocate()
// Replaces: mmap(MAP_ANON) from Android fork
// Requires: com.apple.security.cs.allow-jit entitlement for PROT_EXEC pages
void* HostSys_Alloc(size_t size) {
    vm_address_t addr = 0;
    kern_return_t kr = vm_allocate(mach_task_self(), &addr, size, VM_FLAGS_ANYWHERE);
    if (kr != KERN_SUCCESS) return nullptr;
    return reinterpret_cast<void*>(addr);
}

// TODO Phase 2: Implement using vm_protect()
// JIT pages: call pthread_jit_write_protect_np(false) before write
//            call pthread_jit_write_protect_np(true)  before execute
void HostSys_MemProtect(void* base, size_t size, int prot) {
    vm_prot_t vm_prot = VM_PROT_NONE;

    if (prot & PROT_READ) {
        vm_prot |= VM_PROT_READ;
    }

    bool needs_write = (prot & PROT_WRITE) != 0;
    bool needs_exec = (prot & PROT_EXEC) != 0;

    if (needs_write) {
#if !defined(DISABLE_PCSX2_RECOMPILER) && defined(__APPLE__)
        pthread_jit_write_protect_np(false);
#endif
        vm_prot |= VM_PROT_WRITE;
    }

    if (needs_exec) {
        vm_prot |= VM_PROT_EXECUTE;
    }

    vm_protect(mach_task_self(), (vm_address_t)base, size, FALSE, vm_prot);

    if (needs_exec) {
#if !defined(DISABLE_PCSX2_RECOMPILER) && defined(__APPLE__)
        pthread_jit_write_protect_np(true);
#endif
    }
}

// TODO Phase 2: Implement using vm_deallocate()
void HostSys_Free(void* ptr, size_t size) {
    vm_deallocate(mach_task_self(),
                  reinterpret_cast<vm_address_t>(ptr),
                  size);
}
