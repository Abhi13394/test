SET var=%cd%
ECHO %var%

set mydate=%date:~10,4%_%date:~4,2%_%date:~7,2%
set mytime=%time:~0,2%_%time:~3,2%
set filename=snapshot_before_import_%mydate%_%mytime%

"C:\Program Files\Quadient\Inspire Designer 17.3.437 HF\InspireCLI.exe" -importpackage "C:\AutoDeploy\SnapshotPackage\snapshot.pkg" -createrecoverysnapshot -recoverysnapshotlabel %filename%

pause
exit
