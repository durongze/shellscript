set video_dir=".\fmtflv"
set video_dir=".\fmtmp4"
set video_file="find_gf.mkv"
set gif_file="find_gf.gif"
set subtitle_file="find_gf.srt"
set image_dir=".\img"
set ffmpeg_app=".\ffmpegd.exe"
set ffprobe=".\ffprobed.exe"

@rem 查看录制设备 
@rem %ffmpeg_app% -f dshow -list_devices true -i dummy

@rem %ffmpeg_app% -thread_queue_size 96 -f gdigrab -video_size 1920x1080 -i desktop -f dshow -i video="Integrated Webcam" -video_size 400x300 -filter_complex "[0:v][1:v]overlay=x=main_w-overlay_w-10:y=main_h-overlay_h-10[out]" -map "[out]"  test5.mp4
@rem %ffmpeg_app% -thread_queue_size 128 -f gdigrab -video_size 1920x1080 -framerate 20 -i desktop -f dshow  -i video="Integrated Webcam" -video_size 400x300   -framerate 20 -f dshow -i audio="麦克风 (Realtek Audio)"  -filter_complex "[0:v][1:v]overlay=x=main_w-overlay_w-10:y=main_h-overlay_h-10[out]" -map "[out]"  -map 2:a  -vcodec libx264 -acodec ac3 out.mp4

@rem 录摄像头和麦克风
@rem %ffmpeg_app% -f dshow -i video="Integrated Webcam" -f dshow -i audio="麦克风 (Realtek Audio)"  out.mp4

@rem 录制桌面
@rem %ffmpeg_app% -f gdigrab -framerate 6 -i desktop -f dshow -i audio="麦克风 (Realtek Audio)" out.mp4

@rem 录制窗口
@rem %ffmpeg_app% -f gdigrab -framerate 6 -i title="cmd" out.mp4

@rem 格式转换
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i %%i -f mp3 %%i.mp3 )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy  -f flv "%%i.flv" )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -re -i %%i -c copy  -f hls -bsf:v h264_mp4toannexb %%i.m3u8 )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy "%%i.mp4" )
@rem %ffmpeg_app% -i "%video_file%"   "%video_file%.mp3"

@rem 获取第7s位置的视频帧
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -ss 00:00:7.435 -vframes 1 out.png )
@rem 除以6=0.1s 一张图 除以60=1s -张图
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -vf fps=1/6 thum%%04d.png )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -vf "select='eq(pict_type, PICT_TYPE_I)'" -vsync vfr thum%%04d.png )
@rem %ffmpeg_app% -i "%video_file%" -vf "select='eq(pict_type, PICT_TYPE_I)'" -vsync vfr %image_dir%\thum%%04d.png 

@rem %ffmpeg_app% -y -ss 00:00:01 -t 180 -i "%video_file%"  -f gif -r 1 "%gif_file%"

@rem 推流
@rem %ffmpeg_app% -re -i output.flv -vcodec copy -acodec copy -f flv -y rtmp://192.168.137.147:8935/cctvf/du

@rem 添加字幕
@rem %ffmpeg_app% -y -i %video_file% -vf subtitles=%subtitle_file% %video_file%.mp4
%ffmpeg_app% -y -i %video_file% -i xx.png -filter_complex "overlay=x=10:y=10,subtitles=%subtitle_file%:force_style='Fontsize=44,Shadow=0,MarginV=80'" output.mp4

@rem 显示视频信息
for /r %%i in (%video_dir%\*.*) do (%ffprobe%  -show_format "%%i"  >>times.txt)

pause
