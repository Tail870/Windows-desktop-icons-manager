CuREM Some chores...
@echo off
chcp 65001
setlocal enabledelayedexpansion

REM Set language same as system.
call:setLanguage

REM Clear cmd window.
cls

REM and cd to script's location. Just in case.
REM Could be changed to a correct custom path.
cd %~dp0

REM Start point for getting back,
REM when done a procedure but not exiting.
:start

REM Ask for "save/restore" icons' layout.
echo !save_or_restore_prompt!
set /P src=!s_r_or_c_prompt!

REM If choosed save...
if "!src!"=="s" (
	REM Clear variable for preventing
	REM using old action.
	set "src="

	REM Ask for overwriting file icons_layout.reg during saving.
	echo !file_will_be_owerwritten!
	echo !yn_sure!

	REM There's no checks for file's existance - it WILL be
	REM overwritten if "yes" was choosed.
	set /P yn=!y_or_n_prompt!

	if "!yn!"=="y" (
		REM Clear variable for preventing
		REM using old action.
		set "yn="

		REM Saving icons' layout to file icons_layout.reg.
		reg export HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop "icons_layout.reg" /y
	) else (
		REM Clear variable for preventing
		REM using old action.
		set "yn="
	)

	REM Go back to start.
	goto start
)

REM If choosed restore...
if "!src!"=="r" (
	REM Clear variable for preventing
	REM using old action.
	set "src="
	echo !explorer_will_be_restarted!

	set /P yn=!y_or_n_prompt!
	if "!yn!"=="y" (
		REM Clear variable for preventing
		REM using old action.
		set "yn="

		REM Kill all explorer's processes
		REM to prevent icons' layout
		REM curruption on restore.
		taskkill /F /IM explorer.exe

		REM Restore icons layout
		REM and start explorer.
		reg import "icons_layout.reg"
		Start explorer.exe
	) else (
		REM Clear variable for preventing
		REM using old action.
		set "yn="
	)

	REM Go back to start.
	goto start
)

REM If choosed clear...
if "!src!"=="c" (
	REM Clear variable for preventing
	REM using old action.
	set "src="
	echo !icons_layout_will_be_reseted!
	echo !explorer_will_be_restarted!

	set /P yn=!y_or_n_prompt!
	if "!yn!"=="y" (
		REM Clear variable for preventing
		REM using old action.
		set "yn="

		REM Kill all explorer's processes
		REM to prevent icons' layout
		REM curruption on restore.
		taskkill /F /IM explorer.exe

		REM Reset icons layout
		REM and start explorer.
		reg delete HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop /f
		Start explorer.exe
	) else (
		REM Clear variable for preventing
		REM using old action.
		set "yn="
	)

	REM Go back to start.
	goto start
)

REM Pause before closing window
REM in case of some strange output.
REM Exit before :setLanguage and any other
REM functions in future preventing from 
REM their execution.
pause
exit


REM Set script language same as system's.
:setLanguage

REM Get current system language from Windows' registry.
for /F "tokens=3" %%A in ('reg query "hklm\system\controlset001\control\nls\language" /v "Installlanguage"') do set lcid=%%A
echo !lcid!

REM Choose translated strings according to
REM current system language.
if "!lcid!" == "0409" goto :en-us
if "!lcid!" == "0419" goto :ru-ru
if "!lcid!" == "0809" goto :en-gb

REM If nonw above is aceptable
REM then set default locale (english).
goto :default

REM Locale 0419 - ru-ru
:ru-ru
	set "save_or_restore_prompt=Сохранить! (s), восстановить (r) или сбросить (c) расположение иконок рабочего стола Windows?"
	set "s_r_or_c_prompt=s/r/c (иное - прервать работу скрипта):"
	set "file_will_be_owerwritten=Файл "icons_layout.reg" будет перезаписан^!"
	set "icons_layout_will_be_reseted=Расположение иконок рабочего стола будет сброшено^!"
	set "explorer_will_be_restarted=Проводник будет перезапущен^!"	
	set "yn_sure=Вы уверены?"
	set "y_or_n_prompt=y/n (иное - прервать работу скрипта):"
goto :finalise_localization

REM Locale 0809 - en-gb
:en-gb
REM Locale 0409 - en-us
:en-us
REM Locale unknown - default to english
:default
	set "save_or_restore_prompt=Save (s), restore (r) of reset (c) icons layout on Windows desktop?"
	set "s_r_or_c_prompt=s/r/c (other - stop the script):"
	set "file_will_be_owerwritten=File icons_layout.reg will be overwritten^!"
	set "icons_layout_will_be_reseted=Desktop icons layuot will be reseted^!"
	set "explorer_will_be_restarted=Explorer will be restarted^!"
	set "yn_sure=Are you sure?"
	set "y_or_n_prompt=y/n (other - stop the script):"
goto :finalise_localization

REM Add a space at the end of some strings
REM to separate input from prompt.
:finalise_localization
set "s_r_or_c_prompt=!s_r_or_c_prompt! "
set "y_or_n_prompt=!y_or_n_prompt! "

REM Exit the called procedure.
exit /b