;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

	Name "天元造字 (Beta)"
	OutFile "Compiled\TaoFont-setup.exe"
	Unicode True

	;Default installation folder
	InstallDir "C:\TaoFont"

	;Get installation folder from registry if available
	InstallDirRegKey HKCU "Software\Tao Font" ""

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
;Install Pages

  !define MUI_WELCOMEPAGE_TITLE '天元造字'
  !define MUI_WELCOMEPAGE_TEXT  '歡迎使用天元造字安裝程式，本程式包含四款王漢宗自由字型，字型皆以GNU GPL v2發行。'
  
  !insertmacro MUI_PAGE_WELCOME
#  !insertmacro MUI_PAGE_LICENSE "License.txt"
#  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

;Uninstall Page
#  !insertmacro MUI_UNPAGE_WELCOME
#  !insertmacro MUI_UNPAGE_CONFIRM
#  !insertmacro MUI_UNPAGE_INSTFILES
#  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages
# installation page is set to Traditional Chinese
  !insertmacro MUI_LANGUAGE "TradChinese"

;--------------------------------
;Installer Sections

Section "Main" SecMain
	SetOutPath $INSTDIR

	## read registry and determine if the system encoding is set to Chinese (Traditional, Taiwan)
	ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Nls\Language" "Default"

	## If the locale is not set to 0404 - Chinese (Traditional, Taiwan)
	## Open regional and language option for user to make change the locale
	${If} $1 != "0404"
		Exec "C:\windows\system32\control.exe intl.cpl,,1,2"
		MessageBox MB_OK \
			"請將系統語言設定改為 'Chinese (Traditional, Taiwan)'"
		Quit
	${EndIf}

	## Include the following files and copy them to $INSTDIR (C:\TaoFont is the installation folder)
	File index.xlsx
;	File Tteudc.EXE
	
SectionEnd

Section "Install Fonts" SecFontInstall
	
	## Copy fonts to the fonts subfolder
	SetOutPath $INSTDIR\fonts

	File fonts\wt021.ttf
	File fonts\wt024.ttf
	File fonts\wt064.ttf
	File fonts\wt071.ttf
	File Fonts\wp010-08.ttf

	## Install fonts by copy the fonts to C:\Windows\Fonts, and register the fonts in registry
	CopyFiles $INSTDIR\fonts\*.ttf C:\Windows\Fonts

	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangFangSongMedium (TrueType)" "wt024.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangLiSuMedium (TrueType)" "wt021.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangShinSuMedium (TrueType)" "wt071.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangYanKai (TrueType)" "wt064.ttf"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" "HanWangKaiMediumChuIn (TrueType)" "wp010-08.ttf"

SectionEnd

Section "Fonts Association" SecFontAssociation

	## Associate the created words to the actual fonts

	SetOutPath $INSTDIR\tte

	File tte\FangSong.tte
	File tte\KaiShu.tte
	File tte\LiSu.tte
	File tte\Mingliu.tte
	File tte\YanKai.tte

	WriteRegStr HKCU "EUDC\950" "SystemDefaultEUDCFont" "$INSTDIR\tte\Mingliu.tte"
	WriteRegStr HKCU "EUDC\950" "新細明體" "$INSTDIR\tte\Mingliu.tte"
	WriteRegStr HKCU "EUDC\950" "標楷體" "$INSTDIR\tte\KaiShu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中仿宋繁" "$INSTDIR\tte\FangSong.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中隸書繁" "$INSTDIR\tte\LiSu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗中行書繁" "$INSTDIR\tte\ShinShu.tte"
	WriteRegStr HKCU "EUDC\950" "王漢宗顏楷體繁" "$INSTDIR\tte\YanKai.tte"
	WriteRegStr HKCU "EUDC\950" "細明體" "$INSTDIR\tte\Mingliu.tte"

	## Reboot (Yes/No)
	MessageBox MB_YESNO|MB_ICONQUESTION "是否重新開機？必需要重新開機才能使用造字字型" IDNO +2
	  Reboot

SectionEnd
