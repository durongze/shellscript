@ECHO OFF
    ::以ANSI编码保存批处理
    ::不要再使用变量prompt.bak，因为已经用来保存当前的prompt参数
    ::批处理的最后别忘了ENDLOCAL

    SETLOCAL

    :: 备份旧的prompt参数
    SET prompt.bak=%PROMPT%

    :: 进入"ECHO"部分

        :: 执行每个命令之后都显示提示符 (见下文)
        ECHO ON

        :: 使用ANSI转义序列设置提示符
        :: - 始终以$E1A开头，否则文本会出现在下一行
        :: - 之后是被装饰后的文字
        :: - 最后以 $E30;40m结束，由于前景色与背景色都是黑色，之后输入的命令不可见
        :: - 假定屏幕的默认背景颜色
        @ PROMPT $E[1A$E[30;42mHELLO$E[30;40m

        ::一个 "空 "命令，强制显示提示符
        :: "rem "一词与提示文本一起显示，但不可见
        rem

        :: 如果要显示另一个文本
        @ PROMPT $E[1A$E[33;41mWORLD$E[30;40m
        rem

        :: "ECHO"部分结束
        @ECHO OFF

    :: 利用光标操作ASCII ESC序列的更易读的版本

        :: the initial sequence
        PROMPT $E[1A
        :: formating commands
        PROMPT %PROMPT%$E[32;44m
        :: the text
        PROMPT %PROMPT%This is an "ECHO"ed text...
        :: new line; 2000 is to move to the left "a lot"
        PROMPT %PROMPT%$E[1B$E[2000D
        :: formating commands fro the next line
        PROMPT %PROMPT%$E[33;47m
        :: the text (new line)
        PROMPT %PROMPT%...spreading over two lines
        :: the closing sequence
        PROMPT %PROMPT%$E[30;40m

        :: Looks like this without the intermediate comments:
        :: PROMPT $E[1A
        :: PROMPT %PROMPT%$E[32;44m
        :: PROMPT %PROMPT%This is an "ECHO"ed text...
        :: PROMPT %PROMPT%$E[1B$E[2000D
        :: PROMPT %PROMPT%$E[33;47m
        :: PROMPT %PROMPT%...spreading over two lines
        :: PROMPT %PROMPT%$E[30;40m

        :: show it all at once!
        ECHO ON