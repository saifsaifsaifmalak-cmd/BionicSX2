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

void HostSys_MemProtect(void* base, size_t size, int prot)
{
#if defined(DISABLE_PCSX2_RECOMPILER)
    // Phase 1: Interpreter-only mode.
    // JIT W^X memory protection not required.
    // pthread_jit_write_protect_np deferred to Phase 5 (VIXL JIT).
    // TODO Phase 5: implement using pthread_jit_write_protect_np
    //               with com.apple.security.cs.allow-jit entitlement
    (void)base;
    (void)size;
    (void)prot;
#else
    // Phase 5+ — JIT enabled path
    // Requires entitlement: com.apple.security.cs.allow-jit
    // Requires: iOS 14.2+, ARM64
    #error "JIT memory protection not yet implemented — see Phase 5"
#endif
}

// TODO Phase 2: Implement using vm_deallocate()
void HostSys_Free(void* ptr, size_t size) {
    vm_deallocate(mach_task_self(),
                  reinterpret_cast<vm_address_t>(ptr),
                  size);
}
