// BionicSX2 — libzip stub implementation
// Phase 4: provides minimal stubs to satisfy linker
// Used by SaveState for save state compression

#include <zip.h>

struct zip* zip_open(const char* path, int flags, int* errorp) { return nullptr; }
int zip_close(struct zip* zm) { return 0; }
int zip_discard(struct zip* zm) { return 0; }
const char* zip_strerror(struct zip* zm) { return "stub"; }
int zip_fclose(struct zip* source) { return 0; }
zip_int64_t zip_add(struct zip* za, const char* name, struct zip_source* s) { return -1; }
struct zip_file* zip_fopen(struct zip* za, const char* fname, zip_flags_t flags) { return nullptr; }
struct zip_file* zip_fopen_index(struct zip* za, zip_uint64_t index, zip_flags_t flags) { return nullptr; }
zip_int64_t zip_fread(struct zip_file* zf, void* dest, zip_uint64_t nbytes) { return -1; }
int zip_set_file_compression(struct zip* za, zip_uint64_t idx, zip_int32_t method, zip_uint32_t compress_level) { return 0; }
int zip_source_commit_write(struct zip_source* src) { return 0; }
struct zip_source* zip_source_buffer(struct zip* za, const void* data, zip_int64_t len, int freep) { return nullptr; }
struct zip_source* zip_source_buffer_create(const void* data, zip_int64_t len, int freep, struct zip_error* error) { return nullptr; }
void zip_source_free(struct zip_source* src) {}
struct zip_source* zip_source_file(struct zip* za, const char* fname, zip_uint64_t start, zip_int64_t len) { return nullptr; }
int zip_source_write(struct zip_source* src, const void* data, zip_uint64_t len) { return -1; }
int zip_stat_index(struct zip* za, zip_uint64_t index, zip_flags_t flags, struct zip_stat* st) { return -1; }
struct zip_source* zip_source_zip(struct zip* za, struct zip* src, zip_uint64_t src_index, zip_flags_t flags, zip_int64_t start, zip_int64_t len) { return nullptr; }
int zip_open_from_source(struct zip_source* src, zip_flags_t flags, struct zip_error* error) { return -1; }
int zip_name_locate(struct zip* za, const char* name, zip_flags_t flags) { return -1; }
zip_int64_t zip_file_add(struct zip* za, const char* name, struct zip_source* source, zip_flags_t flags) { return -1; }
struct zip_source* zip_source_begin_write(struct zip_source* src) { return nullptr; }
struct zip_source* zip_source_begin_write_cloning(struct zip_source* src, zip_uint64_t len) { return nullptr; }
int zip_source_open(struct zip_source* src) { return -1; }
int zip_source_read(struct zip_source* src, void* data, zip_uint64_t len) { return -1; }
int zip_source_seek(struct zip_source* src, zip_int64_t offset, int whence) { return -1; }
zip_int64_t zip_source_tell(struct zip_source* src) { return -1; }
int zip_source_close(struct zip_source* src) { return 0; }
zip_int64_t zip_file_replace(struct zip* za, zip_uint64_t idx, struct zip_source* source, zip_flags_t flags) { return -1; }
int zip_delete(struct zip* za, zip_uint64_t idx) { return -1; }
int zip_rename(struct zip* za, zip_uint64_t idx, const char* name) { return -1; }
int zip_file_set_comment(struct zip* za, zip_uint64_t idx, const char* comment, zip_uint16_t len, zip_flags_t flags) { return -1; }
int zip_set_archive_comment(struct zip* za, const char* comment, zip_uint16_t len) { return -1; }
zip_int64_t zip_get_num_entries(struct zip* za, zip_flags_t flags) { return 0; }
const char* zip_get_name(struct zip* za, zip_uint64_t idx, zip_flags_t flags) { return nullptr; }
struct zip_stat* zip_source_stat(struct zip_source* src, struct zip_stat* st) { return nullptr; }
int zip_error_code_zip(const struct zip_error* error) { return 0; }
const char* zip_error_strerror(const struct zip_error* error) { return "stub"; }
struct zip_source* zip_source_function(struct zip* za, zip_source_callback fn, void* ud) { return nullptr; }