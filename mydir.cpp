#define UNICODE
#define _UNICODE
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <aclapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#pragma comment(lib, "advapi32.lib")

static int flag_a;
static int flag_s;
static int flag_q;

static void print_usage(void) {
    fwprintf(stderr, L"usage: mydir [/a] [/s] [/q] [path]\n");
}

static int is_switch(const wchar_t* s) {
    if (!s || s[0] != L'/' && s[0] != L'-')
        return 0;
    wchar_t c = (wchar_t)(s[1] | 0x20);
    if (s[2] != L'\0')
        return 0;
    return c == L'a' || c == L's' || c == L'q';
}

static void apply_switch(wchar_t c) {
    c = (wchar_t)(c | 0x20);
    if (c == L'a')
        flag_a = 1;
    else if (c == L's')
        flag_s = 1;
    else if (c == L'q')
        flag_q = 1;
}

static int is_dots(const wchar_t* name) {
    return (name[0] == L'.' && name[1] == L'\0') ||
           (name[0] == L'.' && name[1] == L'.' && name[2] == L'\0');
}

static int should_list(DWORD attrs) {
    if (flag_a)
        return 1;
    if (attrs & (FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_SYSTEM))
        return 0;
    return 1;
}

static void format_creation_time(const FILETIME* ft, wchar_t* out, size_t outChars) {
    FILETIME lft;
    SYSTEMTIME st;
    if (!FileTimeToLocalFileTime(ft, &lft) || !FileTimeToSystemTime(&lft, &st)) {
        wcsncpy_s(out, outChars, L"?/?/?   ??:??", _TRUNCATE);
        return;
    }
    int hour12 = st.wHour % 12;
    if (hour12 == 0)
        hour12 = 12;
    const wchar_t* ampm = st.wHour < 12 ? L"AM" : L"PM";
    swprintf_s(out, outChars, L"%02u/%02u/%04u  %02u:%02u %s", st.wMonth, st.wDay, st.wYear, hour12,
               st.wMinute, ampm);
}

static int get_owner_string(const wchar_t* fullPath, wchar_t* out, size_t outChars) {
    PSID ownerSid = NULL;
    PSECURITY_DESCRIPTOR sd = NULL;
    DWORD st = GetNamedSecurityInfoW((LPWSTR)fullPath, SE_FILE_OBJECT, OWNER_SECURITY_INFORMATION,
                                     &ownerSid, NULL, NULL, NULL, &sd);
    if (st != ERROR_SUCCESS) {
        swprintf_s(out, outChars, L"(owner error %lu)", st);
        return 0;
    }
    wchar_t name[256], dom[256];
    DWORD nameLen = 256, domLen = 256;
    SID_NAME_USE nu;
    if (!LookupAccountSidW(NULL, ownerSid, name, &nameLen, dom, &domLen, &nu)) {
        swprintf_s(out, outChars, L"(unresolved)");
        LocalFree(sd);
        return 0;
    }
    LocalFree(sd);
    if (domLen > 0 && dom[0] != L'\0')
        swprintf_s(out, outChars, L"%s\\%s", dom, name);
    else
        wcsncpy_s(out, outChars, name, _TRUNCATE);
    return 1;
}

static void print_entry(const wchar_t* fullPath, const WIN32_FIND_DATAW* fd) {
    wchar_t tbuf[64];
    format_creation_time(&fd->ftCreationTime, tbuf, 64);

    ULONGLONG size = ((ULONGLONG)fd->nFileSizeHigh << 32) | fd->nFileSizeLow;
    int isDir = (fd->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0;

    wchar_t owner[512];
    owner[0] = L'\0';
    if (flag_q)
        get_owner_string(fullPath, owner, 512);

    if (isDir) {
        if (flag_q)
            wprintf(L"%s    <DIR>          %s    %s\n", tbuf, owner, fd->cFileName);
        else
            wprintf(L"%s    <DIR>          %s\n", tbuf, fd->cFileName);
    } else {
        if (flag_q)
            wprintf(L"%s    %14llu    %s    %s\n", tbuf, size, owner, fd->cFileName);
        else
            wprintf(L"%s    %14llu    %s\n", tbuf, size, fd->cFileName);
    }
}

static void list_one_directory(const wchar_t* dirPath) {
    wchar_t pattern[MAX_PATH * 2];
    swprintf_s(pattern, MAX_PATH * 2, L"%s\\*", dirPath);

    wchar_t canon[MAX_PATH * 2];
    DWORD gl = GetFullPathNameW(dirPath, MAX_PATH * 2, canon, NULL);
    if (gl == 0 || gl >= MAX_PATH * 2)
        wcsncpy_s(canon, MAX_PATH * 2, dirPath, _TRUNCATE);

    wprintf(L"\n Directory of %s\n\n", canon);

    WIN32_FIND_DATAW fd;
    HANDLE h = FindFirstFileW(pattern, &fd);
    if (h == INVALID_HANDLE_VALUE) {
        fwprintf(stderr, L"mydir: cannot access \"%s\" (%lu)\n", dirPath, GetLastError());
        return;
    }

    enum { MAXSUB = 512 };
    wchar_t(*subdirs)[MAX_PATH * 2] =
        (wchar_t(*)[MAX_PATH * 2])malloc((size_t)MAXSUB * sizeof(*subdirs));
    if (!subdirs) {
        FindClose(h);
        fwprintf(stderr, L"mydir: out of memory\n");
        return;
    }
    int nsub = 0;

    do {
        if (is_dots(fd.cFileName))
            continue;
        if (!should_list(fd.dwFileAttributes))
            continue;

        wchar_t full[MAX_PATH * 2];
        swprintf_s(full, MAX_PATH * 2, L"%s\\%s", dirPath, fd.cFileName);

        print_entry(full, &fd);

        if (flag_s && (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && !is_dots(fd.cFileName) &&
            should_list(fd.dwFileAttributes)) {
            if (nsub < MAXSUB)
                wcsncpy_s(subdirs[nsub++], MAX_PATH * 2, full, _TRUNCATE);
        }
    } while (FindNextFileW(h, &fd));

    FindClose(h);

    for (int i = 0; i < nsub; i++)
        list_one_directory(subdirs[i]);
    free(subdirs);
}

int wmain(int argc, wchar_t** argv) {
    const wchar_t* target = NULL;

    for (int i = 1; i < argc; i++) {
        if (is_switch(argv[i]))
            apply_switch(argv[i][1]);
        else if (!target)
            target = argv[i];
        else {
            fwprintf(stderr, L"mydir: unexpected argument: %s\n", argv[i]);
            print_usage();
            return 1;
        }
    }

    wchar_t cwd[MAX_PATH + 1];
    if (!target) {
        if (!GetCurrentDirectoryW(MAX_PATH + 1, cwd)) {
            fwprintf(stderr, L"mydir: GetCurrentDirectory failed (%lu)\n", GetLastError());
            return 1;
        }
        target = cwd;
    }

    list_one_directory(target);
    wprintf(L"\n");
    return 0;
}
