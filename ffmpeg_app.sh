set video_dir=".\fmtflv"
set video_dir=".\fmtmp4"
set ffmpeg_app=".\ffmpegd.exe"
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i %%i -f mp3 %%i.mp3 )
for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy  -f flv "%%i.flv" )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -re -i %%i -c copy  -f hls -bsf:v h264_mp4toannexb %%i.m3u8 )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy "%%i.mp4" )
pause
