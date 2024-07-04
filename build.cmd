@echo off

setlocal enabledelayedexpansion

set root=%cd%

set "VCPKG_ROOT=%USERPROFILE%\vcpkg"
set "PATH=%VCPKG_ROOT%;%PATH%"

@REM Check if vcpkg is installed
if not exist %VCPKG_ROOT% (
  echo Warn: vcpkg is not installed.
  echo Installing vcpkg...

  cd %USERPROFILE%
  @REM Download vcpkg using Git
  git clone https://github.com/microsoft/vcpkg.git

  @REM Run the vcpkg installation script
  cd vcpkg && bootstrap-vcpkg.bat

  echo vcpkg was successfuly installed.
  echo Please rerun this script.
  cd %root%
)

@REM Check if an argument is provided and validate it
if "%~1"=="" (
  @REM If no arguments are provided, set build type to Debug
  set "build_type=Debug"
) else (
  @REM Convert the argument to lowercase
  set "build_type=%~1"
  set "build_type=!build_type:~0,1!!build_type:~1!"

  @REM Check if the provided argument is either Release or Debug
  if /I "!build_type!"=="release" (
    set "build_type=Release"
  ) else if /I "!build_type!"=="debug" (
    set "build_type=Debug"
  ) else (
    echo Error: Invalid build type '%~1'.
    echo Please specify either 'Release' or 'Debug'.
    exit /b 1
  )
)

@REM Build type message
echo Build type: %build_type%

@REM Run cmake with the appropriate build type
cmake -S . -B build\%build_type% -DCMAKE_BUILD_TYPE=%build_type% --preset=default

@REM Build the targets
cmake --build build\%build_type% --parallel 4

if /I "!build_type!"=="Release" (
  cmake --install build\%build_type%
)

@REM Run tests
set "test_dir=%root%\build\%build_type%\test"
ctest --test-dir %test_dir% --build-config Debug --output-on-failure --parallel 4

endlocal
