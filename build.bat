@ECHO OFF

SETLOCAL
SET BUILDDIR=%~dp0\blogbuster
SET BOOTSTRAP=%~dp0\opt\bootstrap-5.1.3
SET SASSCMD=CALL sass
SET SASSFLAGS=--style compressed --no-source-map

ECHO Copying JS files...
copy "%BOOTSTRAP%\dist\js\bootstrap.bundle.js" "%BUILDDIR%\js\" || GOTO FAIL

ECHO.
ECHO Transpiling SCSS files...
%SASSCMD% %SASSFLAGS% "%BOOTSTRAP%\scss\bootstrap.scss" "%BUILDDIR%\css\bootstrap.min.css" || GOTO FAIL

GOTO END

:FAIL
ECHO.
ECHO THERE ARE ERRORS!
EXIT /B 1

:END
ECHO.
ECHO Done.