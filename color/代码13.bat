@ECHO OFF
    ::��ANSI���뱣��������
    ::��Ҫ��ʹ�ñ���prompt.bak����Ϊ�Ѿ��������浱ǰ��prompt����
    ::���������������ENDLOCAL

    SETLOCAL

    :: ���ݾɵ�prompt����
    SET prompt.bak=%PROMPT%

    :: ����"ECHO"����

        :: ִ��ÿ������֮����ʾ��ʾ�� (������)
        ECHO ON

        :: ʹ��ANSIת������������ʾ��
        :: - ʼ����$E1A��ͷ�������ı����������һ��
        :: - ֮���Ǳ�װ�κ������
        :: - ����� $E30;40m����������ǰ��ɫ�뱳��ɫ���Ǻ�ɫ��֮�����������ɼ�
        :: - �ٶ���Ļ��Ĭ�ϱ�����ɫ
        @ PROMPT $E[1A$E[30;42mHELLO$E[30;40m

        ::һ�� "�� "���ǿ����ʾ��ʾ��
        :: "rem "һ������ʾ�ı�һ����ʾ�������ɼ�
        rem

        :: ���Ҫ��ʾ��һ���ı�
        @ PROMPT $E[1A$E[33;41mWORLD$E[30;40m
        rem

        :: "ECHO"���ֽ���
        @ECHO OFF

    :: ���ù�����ASCII ESC���еĸ��׶��İ汾

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