@echo off
setlocal

where cl >nul 2>nul
if errorlevel 1 (
	set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
	if exist "%VSWHERE%" (
		for /f "usebackq delims=" %%I in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find VC\Auxiliary\Build\vcvars64.bat`) do (
			call "%%I"
		)
	)
	if errorlevel 1 (
		for %%Y in (2022 2019) do (
			for %%E in (BuildTools Community Professional Enterprise) do (
				if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\%%Y\%%E\VC\Auxiliary\Build\vcvars64.bat" (
					call "%ProgramFiles(x86)%\Microsoft Visual Studio\%%Y\%%E\VC\Auxiliary\Build\vcvars64.bat"
				)
			)
		)
	)
)

where cl >nul 2>nul
if errorlevel 1 (
	echo cl.exe is not available. Run from a Visual Studio Developer Command Prompt or install the Visual Studio C++ build tools. 1>&2
	exit /b 1
)

rem With RSS
cl /nologo ntvcm.cxx x80.cxx /DNTVCM_RSS_SUPPORT /openmp /I. /GS- /GL /Oti2 /Ob3 /Qpar /Fa /FAsc /EHac /Zi /jumptablerdata /D_AMD64_ /link user32.lib /OPT:REF

rem Without RSS
rem cl /nologo ntvcm.cxx x80.cxx /I. /GS- /GL /Oti2 /Ob3 /Qpar /Fa /FAsc /EHac /Zi /jumptablerdata /D_AMD64_ /link user32.lib ntdll.lib /OPT:REF

