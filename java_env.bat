set CurDir=%~dp0
set JAVA_HOME=%CurDir%
set CLASSPATH=.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;
set PATH=%PATH%;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;
javac -version
java -version

pause