#define UNICODE
#define _UNICODE
#include <windows.h>
#include <stdio.h>

int wmain(void) {
    wchar_t buf[MAX_PATH + 1];
    DWORD n = GetCurrentDirectoryW(MAX_PATH + 1, buf);
    if (n == 0 || n > MAX_PATH) {
        fwprintf(stderr, L"mypwd: GetCurrentDirectory failed (%lu)\n", GetLastError());
        return 1;
    }
    wprintf(L"%s\n", buf);
    return 0;
}
