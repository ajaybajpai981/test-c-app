@echo off
echo Building hello project with submodules/math_utils...

where gcc >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo Using GCC to build...
    gcc -Wall -I. hello.c submodules/math_utils/math_utils.c -o hello.exe
    if %ERRORLEVEL% equ 0 (
        echo Build successful! Run with: .\hello.exe
    ) else (
        echo Build failed.
    )
    exit /b %ERRORLEVEL%
)

where clang >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo Using Clang to build...
    clang -Wall -I. hello.c submodules/math_utils/math_utils.c -o hello.exe
    if %ERRORLEVEL% equ 0 (
        echo Build successful! Run with: .\hello.exe
    ) else (
        echo Build failed.
    )
    exit /b %ERRORLEVEL%
)

where cl >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo Using MSVC cl.exe to build...
    cl /W4 /I. hello.c submodules\math_utils\math_utils.c /Fe:hello.exe
    if %ERRORLEVEL% equ 0 (
        echo Build successful! Run with: .\hello.exe
    ) else (
        echo Build failed.
    )
    exit /b %ERRORLEVEL%
)

echo No C compiler found (gcc, clang, or cl). Please install MinGW, Clang, or Visual Studio C++ Build Tools.
exit /b 1
