@echo off
title Jenkins Server Launcher
echo ============================================================
echo Starting Jenkins on http://localhost:8080 with Java 21...
echo ============================================================
"C:\Program Files\Java\jdk-21\bin\java.exe" -jar "C:\Users\gowth\Downloads\jenkins.war" --httpPort=8080
pause
