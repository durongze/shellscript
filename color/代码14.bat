@ECHO OFF

    :: ! To observe color effects on prompt below in this script
    ::   run the script from a fresh cmd window with no custom
    ::   prompt settings

    :: Only not to pollute the environment with the %\e% variable (see below)
    :: Not needed because of the `PROMPT` variable
    SETLOCAL

        :: Parsing the `escape` character (ASCII 27) to a %\e% variable
        :: Use %\e% in place of `Esc` in the [http://ascii-table.com/ansi-escape-sequences.php]
        FOR /F "delims=#" %%E IN ('"prompt #$E# & FOR %%E IN (1) DO rem"') DO SET "\e=%%E"

        :: Demonstrate that prompt did not get corrupted by the previous FOR
        ECHO ON
       @ rem : After for
        @ECHO OFF

        :: Some fancy ASCII ESC staff
        ECHO [          ]
        FOR /L %%G IN (1,1,10) DO (
            TIMEOUT /T 1 > NUL
            ECHO %\e%[1A%\e%[%%GC%\e%[31;43m.
            ECHO %\e%[1A%\e%[11C%\e%[37;40m]
        )

        :: ECHO another decorated text
        :: - notice the `%\e%[30C` cursor positioning sequence
        ::   for the sake of the "After ECHO" test below
        ECHO %\e%[1A%\e%[13C%\e%[32;47mHELLO WORLD%\e%[30C

        :: Demonstrate that prompt did not get corrupted by ECHOing
        :: neither does the cursor positioning take effect.
        :: ! But the color settings do.
        ECHO ON
        rem : After ECHO
        @ECHO OFF

    ENDLOCAL

    :: Demonstrate that color settings do not reset
    :: even when out of the SETLOCAL scope
    ECHO ON
    rem : After ENDLOCAL
    @ECHO OFF

    :: Reset the `PROMPT` color
    :: - `PROMPT` itself is untouched so we did not need to backup it.
    :: - Still ECHOING in color apparently collide with user color cmd settings (if any).
    :: ! Resetting `PROMPT` color this way extends the `PROMPT`
    ::   by the initial `$E[37;40m` sequence every time the script runs.
    :: - Better solution then would be to end every (or last) `ECHO` command
    ::   with the `%\e%[37;40m` sequence and avoid setting `PROMPT` altogether.
    ::   which makes this technique preferable to the previous one (before EDIT)
    :: - I am keeping it this way only to be able to
    ::   demonstrate the `ECHO` color effects on the `PROMPT` above.
    PROMPT $E[37;40m%PROMPT%

    ECHO ON
    rem : After PROMPT color reset
    @ECHO OFF

EXIT /B 0