;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

	;Name and file
	Name "天元造字 (Beta)"
	OutFile "Compiled\TaoFont-setup.exe"
	Unicode True

	;Default installation folder
	InstallDir "C:\TaoFont"

#	!define WELCOME_TITLE '天元造字'

#	!define WELCOME_TEXT '歡迎使用天元造字安裝程式。 \
#	本程式包含四款王漢宗自由字型，字型皆以GNU GPL v2發行。'


	;Get installation folder from registry if available
	InstallDirRegKey HKCU "Software\Tao Font" ""

#	LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"

;--------------------------------
;Version Information

#  VIProductVersion "1.0.0.0"
#  VIAddVersionKey  "ProductName" "Tao Font"
#  VIAddVersionKey "Comments" ""
#  VIAddVersionKey  "CompanyName" "To An Origin"
#  VIAddVersionKey "LegalTrademarks" "Test Application is a trademark of Fake company"
#  VIAddVersionKey "LegalCopyright" "Copyright Fake company"
#  VIAddVersionKey  "FileDescription" "Tao Font"
#  VIAddVersionKey  "FileVersion" "1.0.0"

;--------------------------------


;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
#  !define MUI_PAGE_CUSTOMFUNCTION_PRE WelcomePagePre
#  !define MUI_WELCOMEPAGE_TITLE '${WELCOME_TITLE}'
#  !define MUI_WELCOMEPAGE_TEXT '$welcome_text'
#  !insertmacro MUI_PAGE_WELCOME

  !define MUI_WELCOMEPAGE_TITLE '天元造字'
  !define MUI_WELCOMEPAGE_TEXT  '歡迎使用天元造字安裝程式，本程式包含四款王漢宗自由字型，字型皆以GNU GPL v2發行。'
  
  !insertmacro MUI_PAGE_WELCOME
#  !insertmacro MUI_PAGE_LICENSE "License.txt"
#  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

#  !insertmacro MUI_UNPAGE_WELCOME
#  !insertmacro MUI_UNPAGE_CONFIRM
#  !insertmacro MUI_UNPAGE_INSTFILES
#  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "TradChinese"

;--------------------------------
;Installer Sections

Section "Main" SecMain
	SetOutPath $INSTDIR

	ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Nls\Language" "Default"

	## If the locale is not set to 0404 - Chinese (Traditional, Taiwan)
	## Open regional and language option for user to make change the locale
	${If} $1 != "0404"
		Exec "C:\windows\system32\control.exe intl.cpl,,1,2"
		MessageBox MB_OK \
			"請將系統語言設定改為 'Chinese (Traditional, Taiwan)'"
		Quit
	${EndIf}
	
	File Index.xlsx
	File Tteudc.EXE

#	ExecShell "open" "$INSTDIR\Index.xlsx"

	;Create uninstaller
#	WriteUninstaller "$INSTDIR\Uninstall.exe"
	  
#	FileOpen $0 "$INSTDIR\Uninstall.exe" w
#	Rename /REBOOTOK "$INSTDIR\Uninstall.exe" "$INSTDIR\Uninst.exe"
#	FileClose $0
	
SectionEnd

Section "Install Fonts" SecFontInstall

	SetOutPath $INSTDIR\fonts

	File fonts\wt021.ttf
	File fonts\wt024.ttf
	File fonts\wt064.ttf
	File fonts\wt071.ttf

	CopyFiles $INSTDIR\fonts\*.ttf C:\Windows\Fonts

	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangFangSongMedium (TrueType)" "wt024.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangLiSuMedium (TrueType)" "wt021.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangShinSuMedium (TrueType)" "wt071.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangYanKai (TrueType)" "wt064.ttf"

SectionEnd

Section "Fonts Association" SecFontAssociation
	## Associate Fonts

	SetOutPath $INSTDIR\tte

	File tte\FangSong.tte
	File tte\KaiShu.tte
	File tte\LiSu.tte
	File tte\Mingliu.tte
	File tte\ShinShu.tte
	File tte\YanKai.tte

	WriteRegStr HKCU "EUDC\950" "SystemDefaultEUDCFont" "$INSTDIR\tte\Mingliu.tte"
	WriteRegStr HKCU "EUDC\950" "新細明體" "$INSTDIR\tte\Mingliu.tte"
	WriteRegStr HKCU "EUDC\950" "標楷體" "$INSTDIR\tte\KaiShu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中仿宋繁" "$INSTDIR\tte\FangSong.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中隸書繁" "$INSTDIR\tte\LiSu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中行書繁" "$INSTDIR\tte\ShinShu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗顏楷體繁" "$INSTDIR\tte\YanKai.tte"
	WriteRegStr HKCU "EUDC\950" "細明體" "$INSTDIR\tte\Mingliu.tte"

	## Reboot
	MessageBox MB_YESNO|MB_ICONQUESTION "是否重新開機？必需要重新開機才能使用造字字型" IDNO +2
	  Reboot

SectionEnd


Function .onRebootFailed
  MessageBox MB_OK "重新開機失敗！"
FunctionEnd

;--------------------------------
;Descriptions

  ;Language strings
;  LangString DESC_SecFontInstall ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
;  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
;    !insertmacro MUI_DESCRIPTION_TEXT ${SecFontInstall} $(DESC_SecFontInstall)
;  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

;Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

;  Delete "$INSTDIR\Uninstall.exe"

;  RMDir "$INSTDIR"

;  DeleteRegKey /ifempty HKCU "Software\Tao Font"

;SectionEnd
