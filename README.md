# dir / cd / pwd (C++ win32)

Three exes: `mydir.exe`, `mycd.exe`, `mypwd.exe`. Built with MSVC.

## build

Use the x64 Native Tools prompt (or run vcvars64 first), then:

```
cd midterm_dir_cd_pwd
build.bat
```

Or compile by hand:

```
cl /nologo /EHsc /O2 /Fe:mydir.exe mydir.cpp
cl /nologo /EHsc /O2 /Fe:mycd.exe mycd.cpp
cl /nologo /EHsc /O2 /Fe:mypwd.exe mypwd.cpp
```

## mypwd

Prints cwd, one line.

## mycd

`mycd <path>` - SetCurrentDirectory then prints GetCurrentDirectory (required for the midterm writeup).

If you run it from cmd it only changes cwd inside mycd.exe, not the shell after it exits.

## mydir

```
mydir [/a] [/s] [/q] [path]
```

- `/a` - show hidden + system stuff
- `/s` - recurse subfolders
- `/q` - show owner (domain\user)

No path = current directory.

Output has creation time, `<DIR>` or file size, filename. With `/q` owner is in there too.

## github / demo

Put source + exes on a public repo for the class. For the video I ran build.bat, then mydir with flags, mycd, mypwd, and showed some sysmon/procmon stuff for the defensive part.
