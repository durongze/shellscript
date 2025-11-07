::: Cout cursor Macro. Author: T3RRY ::: Filename: Cout.bat
::: OS requirement: Windows 10
::: Purpose: Facilitate advanced console display output with the easy use of Virtual terminal codes
::: Uses a macro function to effect display without users needing to memorise or learn specific
::: virtual terminal sequences.
::: Enables output of text in 255 bit color at absolute or relative Y;X positions.
::: Allows cursor to be hidden or shown during and after text output. See help for more info.

@Echo off & Setlocal EnableExtensions
============================================== :# Usage
 If not "%~1" == "" Echo/%~1.|findstr /LIC:"/?" > nul && (
  If "%~2" == "" (Cls &  Mode 1000,50 & Color 30)
  If "%~2" == "Usage" ( Color 04 & ( Echo/n|choice /n /C:o 2> nul ) & timeout /T 5 > nul )
  If "%~2" == "DE" ( Color 04 & Echo/                      --- Delayed expansion detected^^^! Must not be enabled prior to calling %~n0 ---&( Echo/n|choice /n /C:o 2> nul ))
  If not Exist "%TEMP%\%~n0helpfile.~tmp" (For /F "Delims=" %%G in ('Type "%~f0"^| Findstr.exe /BLIC:":::" 2^> nul ')Do (
   For /F "Tokens=2* Delims=[]" %%v in ("%%G")Do Echo(^|%%v^|
  ))>"%TEMP%\%~n0helpfile.~tmp"
  Type "%TEMP%\%~n0helpfile.~tmp" | More
  timeout /T 60 > nul
  Color 07
  If "%~2" == "DE" (Exit)Else Exit /B 1
 )
 If "!![" == "[" Call "%~f0" "/?" "DE"
:::[=====================================================================================================================]
:::[ cout /?                                                                                                             ]
:::[ %COUT% Cursor output macro.                                                                                         ]
:::[ * Valid Args for COUT: {/Y:Argvalue} {/X:Argvalue} {/S:Argvalue} {/C:Argvalue}                                      ]
:::[       - Args Must be encased in curly braces. Arg order does not matter ; Each Arg is optional.                     ]
:::[ * Valid Switches for COUT: /Save /Alt /Main                                                                         ]
:::[ /Save - Stores the Y and X position at the start of the current expansion to .lY and .lX variables                  ]
:::[ /Alt  - Switch console to alternate screen Buffer. Persists until /Main switch is used.                             ]
:::[ /Main - Restore console to main screen Buffer. Console default is the main buffer.                                  ]
:::[                                                                                                                     ]
:::[   USAGE:                                                                                                            ]
:::[ * ArgValue Options ; '#' is an integer:                                                                             ]
:::[   {/Y:up|down|#} {/Y:up#|down#|#} {/Y:#up|#down|#} {/X:left|right|#} {/X:left#|right#|#} {/X:#left|#right|#}        ]
:::[  * note: {/Y:option} {/X:option} - 1 option only per Arg.                                                           ]
:::[        - directions: 'up' 'down' 'left' 'right' are relative to the cursors last position.                          ]
:::[         - /Y and /X options - #direction or direction#:                                                             ]
:::[           Positions the cursor a number of cells from the current position in the given direction.                  ]
:::[           Example; To move the cursor 5 rows up in the same column, without displaying any new text:                ]
:::[            %COUT%{/Y:5up}                                                                                           ]
:::[        - '#' (Absolute position) is the column number {/X:#} or row number {/Y:#} the cursor                        ]
:::[         * Integers for absolute positions contained in variables must be Expanded: {/Y:%varname%}                   ]
:::[           is to be positioned at, allowing cursor position to be set on single or multiple axis.                    ]
:::[         * Absolute Y and X positions capped at line and column maximum of the console display.                      ]
:::[         * Exceeding the maximum Y positions the cursor at the start of the last line in the console display.        ]
:::[         * Exceeding the maximum X positions the cursor at the start of the next line                                ]
:::[                                                                                                                     ]
:::[   {/S:Output String} {/S:(-)Output String} {/S:Output String(+)} {/S:Output String(K)} {/S:Output String(.#.)}      ]
:::[  * note: (-) Hide or (+) Show the Cursor during output of the string.                                               ]
:::[          (K) Clears the row of text from the position (K) occurs.                                                   ]
:::[          Example; Delete 5 characters from the current row to the right of the curser:                              ]
:::[           %COUT%{/S:(.5.)}                                                                                          ]
:::[   {/C:VTcode} {/C:VTcode-VTcode} {/C:VTcode-VTcode-VTcode}                                                          ]
:::[  * note: Chain multiple graphics rendition codes using '-'                                                          ]
:::[  See:      https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences#text-formatting      ]
:::[  See also: https://www.rapidtables.com/web/color/RGB_Color.html                                                     ]
:::[=====================================================================================================================]

============================================== :# PreScript variable definitions

rem /* generate Vitual Terminal Escape Control .Character */
 For /F %%a in ( 'Echo prompt $E ^| cmd' )Do Set "\E=%%a"
rem /* https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences */
(Set \n=^^^

%= Newline variable for macro definitions. DO NOT MODIFY this line or above 2 lines. =%)

================== :# Screen Dimensions [Customise columns,lines using the mode command.]
 Mode 160,38 & Cls
rem /* Get screen dimensions [lines] [columns]. Must be done before delayed expansion is enabled. */
 For /F "tokens=1,2 Delims=:" %%G in ('Mode')Do For %%b in (%%H)Do For %%a in (%%G)Do Set "%%a=%%b"

rem /* NON ENGLISH VERSION USERS: You will need to manually set Columns and lines for their desired console size */
 If not defined columns (Set "columns=100"& Set "lines=30")

rem /* Cursor position codes - https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences#simple-cursor-positioning */
 Set "left=D"&Set "right=C"&Set "up=A"&set "down=B"
 For /L %%n in (1 1 %lines%)Do (Set "%%ndown=[%%nB"&Set "down%%n=[%%nB"& set "%%nup=[%%nA"&Set "up%%n=[%%nA")
 For /L %%n in (1 1 %columns%)Do (Set "%%nleft=[%%nD"&Set "left%%n=[%%nD"&set "%%nright=[%%nC"&set "right%%n=[%%nC")

%= Catch Args        =%Set COUT=For %%n in (1 2)Do If %%n==2 ( %\n%
%= Test No Args       =%If "!Args!" == "" (CLS^&Echo/Usage Error. Args Required. ^& Call "%~f0" "/?" "Usage" ^|^| Exit /B 1) %\n%
%= Test Braces Used   =%If "!Args:}=!" == "!Args!" (CLS^&Echo/Usage Error. Args must be enclosed in curly braces ^& Call "%~f0" "/?" "Usage" ^|^| Exit /B 1) %\n%
%= Reset macro        =%Set ".Y=" ^& Set ".X=" ^& Set ".Str=" ^& Set ".C=" %\n%
%=  internal vars     =%Set "Arg1=" ^& Set "Arg2=" ^& Set "Arg3=" ^& Set "Arg4=" %\n%
%= Split Args.        =%For /F "Tokens=1,2,3,4 Delims={}" %%1 in ("!Args!")Do ( %\n%
%= Substring           =%Set "Arg1=%%~1" %\n%
%=  modification       =%Set "Arg2=%%~2" %\n%
%=  identifies Args    =%Set "Arg3=%%~3" %\n%
%=  during handling.   =%Set "Arg4=%%~4" %\n%
%=                    =%) %\n%
%= Check /Save switch =%If not "!Args:/Save=!" == "!Args!" (%\n%
%= Reset Cursor Save   =%Set ".Cpos=" ^&Set ".Char="%\n%
%= 10 char max; Repeat =%For /L %%l in (2 1 12)Do (%\n%
%= until R returned     =%If not "!.Char!" == "R" (%\n%
%= from esc[6n          =%^<nul set /p "=%\E%[6n" %\n%
%= Redirects to          =%FOR /L %%z in (1 1 %%l) DO pause ^< CON ^> NUL%\n%
%= prevent blocking      =%Set ".Char=;"%\n%
%= script execution      =%for /F "tokens=1 skip=1 delims=*" %%C in ('"REPLACE /W ? . < con"') DO (Set ".Char=%%C")%\n%
%= Append string w.out R =%If "!.Cpos!" == "" (Set ".Cpos=!.Char!")Else (set ".Cpos=!.Cpos!!.Char:R=!") %\n%
%=                      =%)%\n%
%=                     =%)%\n%
%= Split Captured Pos  =%For /F "tokens=1,2 Delims=;" %%X in ("!.Cpos!")Do Set ".lY=%%X" ^& Set ".LX=%%Y" %\n%
%= End of Pos /Save   =%)%\n%
%= Begin Arg          =%For %%i in (1 2 3 4)Do For %%S in (Y X C S)Do If not "!Arg%%i!" == "" ( %\n%
%= Processing. 4 Args   =%If not "!Arg%%i:/%%S:=!" == "!Arg%%i!" ( %\n%
%= Flagged with Y X C S  =%Set "Arg%%i=!Arg%%i:/%%S:=!" %\n%
%= Strip /Flag In Arg#   =%For %%v in ("!Arg%%i!")Do ( %\n%
%= /Y Lines Arg handling  =%If "%%S" == "Y" ( %\n%
%= Test if arg is variable =%If Not "!%%~v!" == "" ( %\n%
%= assign down / up value   =%Set ".Y=%\E%!%%~v!" %\n%
%= -OR-                    =%)Else ( %\n%
%= assign using operation   =%Set /A ".Y=!Arg%%i!" %\n%
%= to allow use of offsets; =%If !.Y! GEQ !Lines! (Set /A ".Y=Lines-1") %\n%
%= constrained to console   =%Set ".Y=%\E%[!.Y!d" %\n%
%= maximum lines.         =%)) %\n%
%= /X Cols Arg handling   =%If "%%S" == "X" ( %\n%
%= processing follows same =%If Not "!%%~v!" == "" ( %\n%
%= logic as /Y;            =%Set ".X=%\E%!%%~v!" %\n%
%= except if Columns     =%)Else ( %\n%
%= exceed console max     =%Set /A ".X=!Arg%%i!" %\n%
%= columns line wrapping   =%If !.X! GEQ !Columns! (Set ".X=1"^& Set ".Y=%\E%!Down!") %\n%
%= is effected.            =%Set ".X=%\E%[!.X!G" %\n%
%=                       =%)) %\n%
%= /C Color Arg Handling. %If "%%S" == "C" ( %\n%
%= Substituition          =%Set ".C=%\E%[!Arg%%i!" %\n%
%= replaces '-' with VT   =%Set ".C=!.C:-=m%\E%[!" %\n%
%= chain - m\E[           =%Set ".C=!.C!m" %\n%
%=                       =%) %\n%
%= /S String Arg Handle  =%If "%%S" == "S" ( %\n%
%=  Substitute Sub-Args   =%Set ".Str=!Arg%%i!" %\n%
%=  (-) hide cursor        =%Set ".Str=!.Str:(-)=%\E%[?25l!" %\n%
%=  (+) show cursor        =%Set ".Str=!.Str:(+)=%\E%[?25h!" %\n%
%=  (K) clear line         =%Set ".Str=!.Str:(K)=%\E%[K!" %\n%
%=  (.#.) delete # of      =%Set ".Str=!.Str:(.=%\E%[!" %\n%
%=  characters             =%Set ".Str=!.Str:.)=P!" %\n%
%=                       =%) %\n%
%= End Arg Handling   =%))) %\n%
%= /Main /Alt Switch  =%If not "!Args:/Main=!" == "!Args!" ( %\n%
%= handling for       =%^< nul Set /P "=%\E%[?1049l!.Y!!.X!!.C!!.Str!%\E%[0m" %\n%
%= switching console  =%)Else If not "!Args:/Alt=!" == "!Args!" ( %\n%
%= buffers. No Switch =%^< nul Set /P "=%\E%[?1049h!.Y!!.X!!.C!!.Str!%\E%[0m" %\n%
%= outputs to current =%)Else ( ^< nul Set /P "=!.Y!!.X!!.C!!.Str!%\E%[0m" ) %\n%
%= buffer.           =%)Else Set Args=
rem /* Simple subsecond delay macro. Uses call to a non existentent label # number of times to delay script execution. */
 For /F "tokens=1,2 delims==" %%G in ('wmic cpu get maxclockspeed /format:value')Do Set /A "%%G=%%H/20" 2> nul
 If not defined Maxclockspeed Set "Maxclockspeed=200"
 Set "Hash=#"& Set "delay=(If "!Hash!" == "#" (Set /A "Delay.len=Maxclockspeed")Else Set "Delay.len=#")& For /L %%i in (1 1 !Delay.Len!)Do call :[_false-label_] 2> Nul"

============================================== :# Script Body [Demo]
rem /* Enable Delayed Expansion after macro definiton in order to expand macro. */
 Setlocal EnableDelayedExpansion & CD "%TEMP%"
rem /* Usage examples */
 %COUT%{/X:10}{/Y:5}{/C:34}{"/S:(-)hello there^^^!"}
 %Delay%
rem /* Example use of mixed foreground / background color and other graphics rendition properties */
 %COUT%{"/C:31-1-4-48;2;0;80;130"}{/S:Bye for now.}{/Y:down}
 %Delay%
 %COUT%{/Y:up}{/C:35}{/S:again}{/X:16}
 %Delay%
 %COUT%{"/S:(K)^_^"}{/X:right}{/C:32}{/Y:down} /Save
 %Delay%
rem /* Switch to Alternate screen buffer: /Alt */
 %COUT%{"/S:(-)(K)o_o"}{/X:.lX+1}{/Y:6}{/C:33}{/Y:down} /Alt
 %Delay%
 %COUT%{"/S:Don't worry, they'll be back"}{/Y:down}{/X:15left}{/C:7-31}
rem /* Cursor position is tied to the active console buffer. The contents of the Alternate buffer are discarded when reverting to the Main buffer. */
 %Delay%
rem /* Return to Main screen buffer: /Main */
 %COUT%{/X:3left}{/Y:5up}{"/S:That's all folks."} /Save /Main
rem /* Cursor position is tied to the active console buffer. */
 %Delay%
rem /* restore cursor position /Save .lX value with +7 offset ; Overwrite all and delete 6 following characters:(.6.) ; restore cursor: (+) */
     %COUT%{/X:10left}{/S:How(.6.)(+)}{/C:32}
rem /* The same as the above line using VT codes manually. */
 ::: <nul Set /P "=%\E%[10D%\E%[32mHow%\E%[6P%\E%[?25l"
 %Delay%
 %COUT%{/Y:100}
 Endlocal
 Goto :eof