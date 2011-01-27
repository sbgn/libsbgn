@echo off

rem This file is part of the xframe software package
rem hosted at http://xframe.sourceforge.net
rem 
rem Copyright (c) 2003 Kurt Riede.
rem     
rem This library is free software; you can redistribute it and/or
rem modify it under the terms of the GNU Lesser General Public
rem License as published by the Free Software Foundation; either
rem version 2.1 of the License, or (at your option) any later version.
rem 
rem This library is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
rem Lesser General Public License for more details.
rem 
rem You should have received a copy of the GNU Lesser General Public
rem License along with this library; if not, write to the Free Software
rem Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

rem win32 batch file for command line interface of xsddoc.
rem
rem author <a href="mailto:kurt.riede@web.de">Kurt Riede</a>

if "%OS%"=="Windows_NT" @setlocal

set DEFAULT_XSDDOC_HOME=%~dp0..
if "%XSDDOC_HOME%"=="" set XSDDOC_HOME=%DEFAULT_XSDDOC_HOME%
set DEFAULT_XSDDOC_HOME=

set CMD_LINE_ARGS=%1
if ""%1""=="""" goto doneStart
shift
:setupArgs
if ""%1""=="""" goto doneStart
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setupArgs
:doneStart

set LOCALCLASSPATH=%CLASSPATH%
for %%i in ("%XSDDOC_HOME%\lib\*.jar") do call "%XSDDOC_HOME%\bin\lcp.bat" %%i

"%JAVA_HOME%\bin\java.exe" -classpath "%LOCALCLASSPATH%" net.sf.xframe.xsddoc.Main %CMD_LINE_ARGS%

set LOCALCLASSPATH=
set CMD_LINE_ARGS=

if "%OS%"=="Windows_NT" @endlocal
