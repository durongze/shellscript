set video_dir=".\fmtflv"
set video_dir=".\fmtmp4"
set ffmpeg_app=".\ffmpegd.exe"

@rem 查看录制设备 
%ffmpeg_app% -f dshow -list_devices true -i dummy

@rem 录摄像头和麦克风
%ffmpeg_app% -f dshow -i video="Integrated Webcam" -f dshow -i audio="麦克风 (Realtek Audio)"  out.mp4

@rem 录制桌面
@rem %ffmpeg_app% -f gdigrab -framerate 6 -i desktop out.mp4

@rem 录制窗口
@rem %ffmpeg_app% -f gdigrab -framerate 6 -i title="cmd" out.mp4

@rem 格式转换
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i %%i -f mp3 %%i.mp3 )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy  -f flv "%%i.flv" )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -re -i %%i -c copy  -f hls -bsf:v h264_mp4toannexb %%i.m3u8 )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -c copy "%%i.mp4" )

@rem 获取第7s位置的视频帧
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -ss 00:00:7.435 -vframes 1 out.png )
@rem 除以6=0.1s 一张图 除以60=1s -张图
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -vf fps=1/6 thum%%04d.png )
@rem for /r %%i in (%video_dir%\*.*) do (%ffmpeg_app% -i "%%i" -vf "select='eq(pict_type, PICT_TYPE_I)'" -vsync vfr thum%%04d.png )

@rem 推流
@rem %ffmpeg_app% -re -i output.flv -vcodec copy -acodec copy -f flv -y rtmp://192.168.137.147:8935/cctvf/du


@rem dumpbin /LINKERMEMBER  libgmp.lib | findstr ___gmpn_add_n
@rem dumpbin /exports avcodec-57.dll
