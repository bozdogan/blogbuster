@ECHO OFF
REM Build template package for distribution
REM Most probably to use with an in-house website generator

SETLOCAL
SET SOURCEDIR=%~dp0\src
SET BUILDDIR=%~dp0\dist

SET BOOTSTRAP=%~dp0\opt\bootstrap-5.1.3
SET SASSCMD=CALL sass
SET SASSFLAGS=--style compressed --no-source-map --load-path=%BOOTSTRAP%\scss

IF NOT EXIST "%BUILDDIR%" (
    ECHO Creating build directory.
    ECHO.
    mkdir "%BUILDDIR%" )

ECHO Copying vendor JS files...
IF NOT EXIST "%BUILDDIR%\assets\js\" ( mkdir "%BUILDDIR%\assets\js" )
copy "%BOOTSTRAP%\dist\js\bootstrap.bundle.js" "%BUILDDIR%\assets\js\" || GOTO FAIL

ECHO.
ECHO Copying JS files...
IF EXIST "%SOURCEDIR%\js\" (
    xcopy /S /Y "%SOURCEDIR%\js\" "%BUILDDIR%\assets\js" || GOTO FAIL )

ECHO.
ECHO Transpiling SCSS files...
IF NOT EXIST "%BUILDDIR%\assets\css\" ( mkdir "%BUILDDIR%\assets\css" )
%SASSCMD% %SASSFLAGS% "%SOURCEDIR%\scss":"%BUILDDIR%\assets\css" || GOTO FAIL

ECHO.
ECHO Copying CSS files...
IF EXIST "%SOURCEDIR%\css\" (
    xcopy /S /Y "%SOURCEDIR%\css\" "%BUILDDIR%\assets\css" || GOTO FAIL )

ECHO.
ECHO Copying views
xcopy /S /Y "%SOURCEDIR%\views\*.html" "%BUILDDIR%\views\" || GOTO FAIL

ECHO.
ECHO Copying static assets...
IF EXIST "%SOURCEDIR%\res\" (
    xcopy /S /Y "%SOURCEDIR%\res\" "%BUILDDIR%\assets\res" || GOTO FAIL )

GOTO END

:FAIL
ECHO.
ECHO THERE ARE ERRORS!
EXIT /B 1

:END
ECHO.
ECHO Done.