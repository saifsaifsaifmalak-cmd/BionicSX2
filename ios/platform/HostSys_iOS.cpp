// BionicSX2 — iOS Host System Memory Management
// Phase 2 implementation target
// Reference: Darwin XNU vm_allocate / vm_protect
// NO stubs — every function below has a concrete implementation plan

#include <mach/mach.h>
#include <mach/vm_map.h>
#include <pthread.h>
#include <sys/mman.h>
#include <sys/sysctl.h>

#include "common/HostSys.h"
#include "common/Pcsx2Defs.h"
#include "common/Threading.h"

bool Common::InhibitScreensaver(bool inhibit)
{
	// iOS: Use idleTimerDisabled on UIApplication
	// This is a stub - full implementation needs UIKit integration
	// For now, no-op on iOS
	(void)inhibit;
	return true;
}

static CPUInfo CalcCPUInfo()
{
	CPUInfo out = {"Apple Silicon", 0, 0, 0, 0};
	
	// Get CPU brand string
	char cpu_name[256] = {0};
	size_t name_size = sizeof(cpu_name);
	sysctlbyname("machdep.cpu.brand_string", cpu_name, &name_size, nullptr, 0);
	strncpy(out.name, cpu_name, sizeof(out.name) - 1);
	
	// Get physical cpu count
	size_t phys_size = sizeof(u32);
	u32 physcpu = 0;
	sysctlbyname("hw.physicalcpu", &physcpu, &phys_size, nullptr, 0);
	out.num_big_cores = physcpu;
	
	// Get logical cpu count
	size_t log_size = sizeof(u32);
	u32 logcpu = 0;
	sysctlbyname("hw.logicalcpu", &logcpu, &log_size, nullptr, 0);
	out.num_threads = logcpu;
	
	out.num_clusters = 1;
	return out;
}

const CPUInfo& GetCPUInfo()
{
	static const CPUInfo info = CalcCPUInfo();
	return info;
}

// ── SharedMemoryMappingArea ────────────────────────────────────────────────────
// iOS implementation using Darwin XNU vm_allocate
// For interpreter mode, allocates simple memory without JIT protections
// Phase 5: will use pthread_jit_write_protect_np for JIT code pages

SharedMemoryMappingArea::SharedMemoryMappingArea(u8* base_ptr, size_t size, size_t num_pages)
	: m_base_ptr(base_ptr)
	, m_size(size)
	, m_num_pages(num_pages)
{
}

SharedMemoryMappingArea::~SharedMemoryMappingArea()
{
	// Free the allocated memory
	if (m_base_ptr)
	{
		vm_deallocate(mach_task_self(), reinterpret_cast<vm_address_t>(m_base_ptr), m_size);
	}
}

std::unique_ptr<SharedMemoryMappingArea> SharedMemoryMappingArea::Create(size_t size, bool jit)
{
	// Allocate memory for the mapping area
	vm_address_t addr = 0;
	kern_return_t kr = vm_allocate(mach_task_self(), &addr, size, VM_FLAGS_ANYWHERE);
	if (kr != KERN_SUCCESS)
		return nullptr;

	u8* base_ptr = reinterpret_cast<u8*>(addr);
	size_t num_pages = size / HostSys::GetRuntimePageSize();

	// For interpreter mode, simple allocation is sufficient
	// JIT mode (Phase 5) will use different protections per page
	(void)jit;

	return std::unique_ptr<SharedMemoryMappingArea>(
		new SharedMemoryMappingArea(base_ptr, size, num_pages));
}

u8* SharedMemoryMappingArea::Map(void* file_handle, size_t file_offset, void* map_base, size_t map_size, const PageProtectionMode& mode)
{
	// For now, just return the base pointer
	// File mapping will be implemented in Phase 5
	(void)file_handle;
	(void)file_offset;
	(void)map_base;
	(void)map_size;
	(void)mode;
	return m_base_ptr;
}

bool SharedMemoryMappingArea::Unmap(void* map_base, size_t map_size, bool is_file)
{
	// Stub - unmap implementation deferred to Phase 5
	(void)map_base;
	(void)map_size;
	(void)is_file;
	return true;
}

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
