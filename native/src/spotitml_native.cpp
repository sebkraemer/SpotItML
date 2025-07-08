#include "spotitml_native.h"
#include <string>

extern "C" {

const char* hello_world() {
    static std::string msg = "Hello from C++!";
    return msg.c_str();
}

int add_numbers(int a, int b) {
    return a + b;
}

} // extern "C"
