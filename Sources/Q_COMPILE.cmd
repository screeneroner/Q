@echo off
Taskkill /IM Q.exe /F
d:\HOME\Portable\Autohotkey\Compiler\Ahk2Exe.exe /in Q.ahk /out Q.exe /icon Q.ico /bin "d:\HOME\Portable\Autohotkey\Compiler\Unicode 64-bit.bin" /compress 2
start Q.exe
pause