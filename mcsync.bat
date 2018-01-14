@echo off
echo Getting elevated privilages...
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)
echo Got elevated privilages.

set foldername=mcsaves

echo Link will be created at: %OneDrive%\%foldername%
echo Minecraft saves is at: %APPDATA%\.minecraft\saves
echo Creating link...
mklink /J %OneDrive%\%foldername% %APPDATA%\.minecraft\saves
echo Created link.
echo Done! Run this script on all devices that you want your worlds to sync across. Make sure to never have Minecraft running on 2 synced devices at the same time or your worlds may be corrupted! Make sure to allow time for worlds to sync after quitting Minecraft.
pause