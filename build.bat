@ECHO OFF
REM Build 3rd party distributions and my modifications to them.

SETLOCAL
SET SOURCEDIR=%~dp0\src
SET BUILDDIR=%~dp0\preview
SET BOOTSTRAP=%~dp0\opt\bootstrap-5.1.3
SET SASSCMD=CALL sass
SET SASSFLAGS=--style compressed --no-source-map --load-path=%BOOTSTRAP%\scss %1

ECHO Copying vendor JS files...
IF NOT EXIST "%BUILDDIR%\js\" ( mkdir "%BUILDDIR%\js" )
copy "%BOOTSTRAP%\dist\js\bootstrap.bundle.js" "%BUILDDIR%\js\" || GOTO FAIL

ECHO.
ECHO Copying JS files...
IF EXIST "%SOURCEDIR%\js\" (
    xcopy /S /Y "%SOURCEDIR%\js\" "%BUILDDIR%\js" || GOTO FAIL )

ECHO.
ECHO Copying CSS files...
IF EXIST "%SOURCEDIR%\css\" (
    xcopy /S /Y "%SOURCEDIR%\css\" "%BUILDDIR%\css" || GOTO FAIL )

ECHO.
ECHO Copying views...
xcopy /S /Y "%SOURCEDIR%\views\*.html" "%BUILDDIR%\" || GOTO FAIL

ECHO.
ECHO Transpiling SCSS files...
%SASSCMD% %SASSFLAGS% "%SOURCEDIR%\scss":"%BUILDDIR%\css" || GOTO FAIL

GOTO END

:FAIL
ECHO.
ECHO THERE ARE ERRORS!
EXIT /B 1

:END
ECHO.
ECHO Done.