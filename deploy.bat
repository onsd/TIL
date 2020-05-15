@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ REM ######################################
@ REM # Variable to ignore mixed paths
@ REM # i.e. G:/$SOPC_KIT_NIOS2/bin
@ set CYGWIN=nodosfilewarning

@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64


%QUARTUS_BIN%\\quartus_map --read_settings_files=on --write_settings_files=off DE10_LITE_Default -c DE10_LITE_Default
%QUARTUS_BIN%\\quartus_fit --read_settings_files=off --write_settings_files=off DE10_LITE_Default -c DE10_LITE_Default
%QUARTUS_BIN%\\quartus_asm --read_settings_files=off --write_settings_files=off DE10_LITE_Default -c DE10_LITE_Default
%QUARTUS_BIN%\\quartus_sta DE10_LITE_Default -c DE10_LITE_Default

%QUARTUS_BIN%\\quartus_pgm.exe -m jtag -c 1 -o "p;DE10_LITE_Default.sof"
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%

pause



