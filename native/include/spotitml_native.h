#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Returns a pointer to a null-terminated hello world string.
// The caller should not free the returned pointer.
const char* hello_world(void);

// Adds two integers and returns the result.
int add_numbers(int a, int b);

#ifdef __cplusplus
}
#endif

