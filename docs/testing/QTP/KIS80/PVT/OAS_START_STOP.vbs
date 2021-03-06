Sub OAS_START_STOP
	Dim blnResult
	Dim CWorkAreaHomeAntivirusSettings
	
	blnResult = True
	Set CWorkAreaHomeAntivirusSettings = New CWorkAreaHomeAntivirus

	OpenMainWindow()
	
	If SelectMainWindowNavigatorButton("ANTIVIRUS", "HOME") = True Then
		LogEvent "PASS", "SelectMainWindowNavigatorButton(""ANTIVIRUS"", ""HOME"")", "Area ""ANTIVIRUS"", ""HOME"" selected"
	Else
		LogEvent "FAIL", "SelectMainWindowNavigatorButton(""ANTIVIRUS"", ""HOME"")", "Can't select ""ANTIVIRUS"", ""HOME"" area"
	End If
	
	CWorkAreaHomeAntivirusSettings.txtModule = "FILEMONITORING" ' File Monitor, E-mail, Web
	CWorkAreaHomeAntivirusSettings.txtMonitoring = 1 'Monitoryng Enable/Disable
	CWorkAreaHomeAntivirusSettings.intDepthLevelHigh = 0 'Protection Level High
	CWorkAreaHomeAntivirusSettings.intDepthLevelMedium = 1 'Protection Level Medium
	CWorkAreaHomeAntivirusSettings.intDepthLevelLow = 0 'Protection Level Low
	CWorkAreaHomeAntivirusSettings.intOnDetectAskDetect = 1 'Prompt immediately
	CWorkAreaHomeAntivirusSettings.intOnDetectDontAsk = 0 ' Don`t prompt
	CWorkAreaHomeAntivirusSettings.intOnDetectTryDisinfect = 0 ' Desinfect
	CWorkAreaHomeAntivirusSettings.intOnDetectTryDelete = 0'Delete if desinfection fails
	'CWorkAreaHomeAntivirusSettings.intAsk 'Prompt ()only Web Antivirus
	'CWorkAreaHomeAntivirusSettings.intBlock 'Don`t prompt, block (only web)
	'CWorkAreaHomeAntivirusSettings.intAllow 'Don`t prompt , Allow (Only Web)
	if SetWorkAreaHomeAntivirus(CWorkAreaHomeAntivirusSettings) = False Then
		LogEvent "FAIL", "OAS_START_STOP", "SetWorkAreaHomeAntivirus = False"
	End If
	
	CWorkAreaHomeAntivirusSettings.txtMonitoring = IMAGE_CHECK_OFF 'Monitoryng Enable/Disable
	
	If SetWorkAreaHomeAntivirus(CWorkAreaHomeAntivirusSettings) = False Then
		LogEvent "FAIL", "OAS_START_STOP", "SetWorkAreaHomeAntivirus = False"
	End IF
	
	CreateEICAR("C:\EICAR.COM")
	
	On error resume next
    systemutil.Run("C:\EICAR.COM")
	
	If AlertExist(10) = True Then
		LogEvent "FAIL", "AlertExist(10)", "Alert Exist"
		AlertDialogAction "DELETE"
	Else
		LogEvent "PASS", "AlertExist(10)", "Alert Not Found"
	End If
	
	On error goto 0
	
	CWorkAreaHomeAntivirusSettings.txtMonitoring = IMAGE_CHECK_ON 'Monitoryng Enable/Disable
	
	If SetWorkAreaHomeAntivirus(CWorkAreaHomeAntivirusSettings) = False Then
		LogEvent "FAIL", "OAS_START_STOP", "SetWorkAreaHomeAntivirus = False"
	End IF
	
	CreateEICAR("C:\EICAR.COM")
	
	On error resume next
    systemutil.Run("C:\EICAR.COM")
	
	If AlertExist(5) = True Then
		LogEvent "PASS", "AlertExist(5)", "Alert Exist"
		AlertDialogAction "DELETE"
	Else
		LogEvent "FAIL", "AlertExist(5)", "Alert Not Found"
	End If
	
	On error goto 0
	
	If FileExists("C:\EICAR.COM") = True Then
		LogEvent "FAIL", "FileExists", "Eicar not deleted"
	End If
	
End Sub
