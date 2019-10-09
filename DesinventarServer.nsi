; DesInventar Server Installer script
;
;--------------------------------

; The name of the installer
Name "DesInventar Server"

; The file to write
OutFile "setup.exe"

; Vista issue with shortcuts...
RequestExecutionLevel admin
; The default installation directory
InstallDir "$PROGRAMFILES\DesInventar Server"

LoadLanguageFile "\Program Files\NSIS\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "\Program Files\NSIS\Contrib\Language files\English.nlf"
LoadLanguageFile "\Program Files\NSIS\Contrib\Language files\French.nlf"

LangString welcomeMsg ${LANG_ENGLISH} "Welcome to DesInventar"
LangString welcomeMsg ${LANG_FRENCH} "Bienvenue a DesInventar"
LangString welcomeMsg ${LANG_SPANISH} "Bienvenido a DesInventar"


LangString IacceptMsg ${LANG_ENGLISH} "I accept the DesInventar License"
LangString IacceptMsg ${LANG_FRENCH} "Je acepté la license du DesInventar"
LangString IacceptMsg ${LANG_SPANISH} "Acepto la licencia de DesInventar"

LicenseLangString DiLicenseData  ${LANG_ENGLISH} "LICENSE.rtf"
LicenseLangString DiLicenseData  ${LANG_FRENCH}  "LICENSE.rtf"
LicenseLangString DiLicenseData  ${LANG_SPANISH} "LICENSE.rtf"
LicenseData $(DiLicenseData)
LicenseForceSelection checkbox 

;--------------------------------

 Page license
; Page components
 Page directory
 Page instfiles

 UninstPage uninstConfirm
 UninstPage instfiles


;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; delete previous class and lib files
  Exec ' del /Q /S "$INSTDIR\Server\webapps\DesInventar\WEB-INF\classes\*.class"'
  
   
  ; Put all files there
  File /r *.*

CreateDirectory "$SMPROGRAMS\DesInventar Server"
CreateShortCut "$SMPROGRAMS\DesInventar Server\DesInventar.lnk" "http://localhost:8081/DesInventar"   "" "" 2 SW_SHOWNORMAL  
CreateShortCut "$SMPROGRAMS\DesInventar Server\DesInventar User Manual.lnk" "$INSTDIR\Server\webapps\DesInventar\DesInventar-UserManual.doc"   "" "" 2 SW_SHOWNORMAL  
CreateShortCut "$SMPROGRAMS\DesInventar Server\DesConsultar User Manual.lnk" "$INSTDIR\Server\webapps\DesInventar\DesConsultar-UserManual.doc"   "" "" 2 SW_SHOWNORMAL  
CreateShortCut "$SMPROGRAMS\DesInventar Server\Database Scripts.lnk" "$INSTDIR\Server\webapps\DesInventar\scripts\"   "" "" 2 SW_SHOWNORMAL  
CreateShortCut "$SMPROGRAMS\DesInventar Server\Import Map Utility.lnk" "$INSTDIR\Server\webapps\DesInventar\WEB-INF\exe\importxy.exe"   "" "" 2 SW_SHOWNORMAL  
CreateShortCut "$SMPROGRAMS\DesInventar Server\Start Server.lnk" "$INSTDIR\Server\bin\startup.bat"   "" "" 2 SW_SHOWMINIMIZED  
CreateShortCut "$SMPROGRAMS\DesInventar Server\Stop Server.lnk" "$INSTDIR\Server\bin\stop.bat"   "" "" 2 SW_SHOWMINIMIZED  

; CreateShortCut "$SMPROGRAMS\Startup\DesInventar Monitor.lnk" "$INSTDIR\Server\bin\tomcat5w.exe" "//MS//DesInventar"  "" 2 SW_SHOWMINIMIZED  


Exec '"$INSTDIR\Server\bin\InstallService.bat" "$INSTDIR\Server"'
;Create uninstaller
WriteUninstaller "$INSTDIR\Uninstall.exe"

; add shortcut to uninstaller
CreateShortCut "$SMPROGRAMS\DesInventar Server\Uninstall DesInventar.lnk" "$INSTDIR\Uninstall.exe"


SectionEnd ; end the section


Function .onInit

    ;Language selection dialog

    Push ""
    Push ${LANG_ENGLISH}
    Push English
    Push ${LANG_SPANISH}
    Push Spanish
    Push ${LANG_FRENCH}
    Push French
    Push A ; A means auto count languages
           ; for the auto count to work the first empty push (Push "") must remain
    LangDLL::LangDialog "Installer Language" "Please select the language of the installer"

    Pop $LANGUAGE
    StrCmp $LANGUAGE "cancel" 0 +2
        Abort
FunctionEnd
;--------------------------------
;Uninstaller Section

Section "Uninstall"



Exec '"$INSTDIR\Server\bin\sc stop DesInventar" "$INSTDIR\Server\bin"'
Exec '"$INSTDIR\Server\bin\sc Delete DesInventar" "$INSTDIR\Server\bin"'
Exec '"$INSTDIR\Server\bin\RemoveService.bat" "$INSTDIR\Server\bin"'



Delete "$INSTDIR\Uninstall.exe"

RMDir /r  "$INSTDIR\Server"
RMDir /r  "$INSTDIR"
RMDir /r /REBOOTOK "$INSTDIR\Server"
RMDir /r /REBOOTOK "$INSTDIR"

  


Delete "$SMPROGRAMS\DesInventar Server\DesInventar.lnk"
Delete "$SMPROGRAMS\DesInventar Server\DesInventar User Manual.lnk" 
;Delete  "$SMPROGRAMS\DesInventar Server\Database Scripts.lnk" 
Delete "$SMPROGRAMS\DesInventar Server\Start Server.lnk"
Delete "$SMPROGRAMS\DesInventar Server\Stop Server.lnk" 
;Delete "$SMPROGRAMS\Startup\DesInventar Monitor.lnk"
Delete "$SMPROGRAMS\DesInventar Server\Uninstall DesInventar.lnk"

Delete "$SMPROGRAMS\DesInventar Server\DesConsultar User Manual.lnk"
Delete "$SMPROGRAMS\DesInventar Server\Database Scripts.lnk" 
delete "$SMPROGRAMS\DesInventar Server\Import Map Utility.lnk"

CreateShortCut "$SMPROGRAMS\DesInventar Server\Start Server.lnk" "$INSTDIR\Server\bin\startup.bat"   "" "" 2 SW_SHOWMINIMIZED  
CreateShortCut "$SMPROGRAMS\DesInventar Server\Stop Server.lnk" "$INSTDIR\Server\bin\stop.bat"   "" "" 2 SW_SHOWMINIMIZED  



Delete  "$SMPROGRAMS\DesInventar Server\*.*" 

; delete start menu files
Exec 'del /Q /S "$SMPROGRAMS\DesInventar  Server\*.*"'
  

  
;Delete empty start menu parent diretories
 
RMDir  /r "$SMPROGRAMS\DesInventar Server"
RMDir  /r /REBOOTOK "$SMPROGRAMS\DesInventar Server"


SectionEnd
