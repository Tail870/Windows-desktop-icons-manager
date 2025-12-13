# Customization
Curently there's two customization points:
- setting a custom working directory;
- writing a custom translation inside :setLanguage procedure.
## Custom working diractory
At the start of script (let's call it "chores" section) there's a "cd" function:
```bat
REM and cd to script's location. Just in case.
REM Could be changed to a correct custom path.
cd %~dp0
```
By default during saving icons' layout *.reg file will be saved in script's location.
You can change it to look like this:
```bat
REM and cd to script's location. Just in case.
REM Could be changed to a correct custom path.
cd %USERPROFILE%\Documents
```
This will allow you to save icons layout backups *.reg file to user's Documents folder in his profile (usually ```C:\Users\%USERNAME%```).

## Custom localization
You can add custom localization to translate script to your languge inside :setLanguage procedure at the end of script.

For example - russian locale (ru-ru) looks like this:
```bat
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
```

For example - english locale (en-us, en-gb) looks like this:
```bat
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

```

At the start of procedure you should add a correct goto section right after "for" function ("echo" is for displaying LCID during debuging):
```bat
for /F "tokens=3" %%A in ('reg query "hklm\system\controlset001\control\nls\language" /v "Installlanguage"') do set lcid=%%A
echo !lcid!

REM Choose translated strings according to
REM current system language.
if "!lcid!" == "0409" goto :en-us
if "!lcid!" == "0419" goto :ru-ru
if "!lcid!" == "0809" goto :en-gb
```
For LCID values go to Windows Language Code Identifier (LCID) Reference [here](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/70feba9f-294e-491e-b6eb-56532684c37f).
