@ECHO OFF
IF "%VIRTUAL_ENV%" == "" ( CALL env || GOTO FAIL )

REM Build 3rd party distributions and my modifications to them.
SETLOCAL
SET SOURCEDIR=%~dp0\src
SET BUILDDIR=%~dp0\preview
SET BOOTSTRAP=%~dp0\opt\bootstrap-5.1.3
SET SASSCMD=CALL sass
SET SASSFLAGS=--style compressed --no-source-map --load-path=%BOOTSTRAP%\scss %1

python -m sitegenlib template --preview -t %SOURCEDIR% -o %BUILDDIR% -v || GOTO FAIL

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
