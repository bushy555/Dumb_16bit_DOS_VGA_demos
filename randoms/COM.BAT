@echo off
@h:\lang\masm\bin\masm %1;
@h:\lang\masm\bin\link %1;
@g:\ibm_pc\msdos\v5.00\exe2bin %1.exe %1.com
