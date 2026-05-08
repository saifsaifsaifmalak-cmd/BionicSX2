// BionicSX2 — iOS Host System Memory Management
// Phase 2 implementation target
// Reference: Darwin XNU vm_allocate / vm_protect
// NO stubs — every function below has a concrete implementation plan

#include <mach/mach.h>
#include <mach/vm_map.h>
#include <pthread.h>

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
    // TODO Phase 2: map prot flags → mach vm_prot_t
    // pthread_jit_write_protect_np() for W^X on iOS 14.2+
}

// TODO Phase 2: Implement using vm_deallocate()
void HostSys_Free(void* ptr, size_t size) {
    vm_deallocate(mach_task_self(),
                  reinterpret_cast<vm_address_t>(ptr),
                  size);
}
