@echo off
echo ======================================================================
echo   WebEase - Full Stack Java Mini Project Launcher
echo ======================================================================
echo Starting Apache Tomcat Server...
cmd.exe /c "C:\Users\rishimishra\apache-tomcat-9.0.99\bin\startup.bat"
echo.
echo Server starting on http://localhost:8080/webease/
timeout /t 3 >nul
start http://localhost:8080/webease/
pause