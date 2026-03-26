#define UNICODE
#define _UNICODE
#include <windows.h>
#include <stdio.h>

static void print_usage(void) {
    fwprintf(stderr, L"usage: mycd <path>\n");
}

int wmain(int argc, wchar_t** argv) {
    if (argc != 2) {
        print_usage();
        return 1;
    }

    if (!SetCurrentDirectoryW(argv[1])) {
        fwprintf(stderr, L"mycd: could not change to \"%s\" (%lu)\n", argv[1], GetLastError());
        return 1;
    }

    wchar_t buf[MAX_PATH + 1];
    DWORD n = GetCurrentDirectoryW(MAX_PATH + 1, buf);
    if (n == 0 || n > MAX_PATH) {
        fwprintf(stderr, L"mycd: GetCurrentDirectory failed (%lu)\n", GetLastError());
        return 1;
    }

    wprintf(L"Current directory is now:\n%s\n", buf);
    return 0;
}
