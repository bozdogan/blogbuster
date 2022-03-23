@ECHO OFF
REM Build 3rd party distributions and my modifications to them.

SETLOCAL
SET SOURCEDIR=%~dp0\src
SET ASSETSDIR=%~dp0\static
SET BUILDDIR=%~dp0\dist

SET BOOTSTRAP=%~dp0\opt\bootstrap-5.1.3
SET SASSCMD=CALL sass
SET SASSFLAGS=--style compressed --no-source-map --load-path=%BOOTSTRAP%\scss %1

IF NOT EXIST "%BUILDDIR%" (
    ECHO Creating build directory.
    mkdir "%BUILDDIR%" )

ECHO Copying JS files...
IF NOT EXIST "%BUILDDIR%\js\" ( mkdir "%BUILDDIR%\js" )
copy "%BOOTSTRAP%\dist\js\bootstrap.bundle.js" "%BUILDDIR%\js\" || GOTO FAIL

ECHO.
ECHO Transpiling SCSS files...
IF NOT EXIST "%BUILDDIR%\css\" ( mkdir "%BUILDDIR%\css" )
%SASSCMD% %SASSFLAGS% "%SOURCEDIR%\scss":"%BUILDDIR%\css" || GOTO FAIL

ECHO.
ECHO Copying views
xcopy /S /Y "%SOURCEDIR%\views\*" "%BUILDDIR%\views\" || GOTO FAIL

ECHO.
ECHO Copying static assets...
xcopy /S /Y "%ASSETSDIR%\*" "%BUILDDIR%" || GOTO FAIL

GOTO END

:FAIL
ECHO.
ECHO THERE ARE ERRORS!
EXIT /B 1

:END
ECHO.
ECHO Done.