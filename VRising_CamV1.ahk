#IfWinActive, VRising

#SingleInstance Force
#Persistent

mode1 := false
mode2 := false
savedMode1 := false
savedMode2 := false
tempDeactivated := false
rButtonHeld := false

; Initial Hotkey Setup
UpdateHotkeys()

F1::
	mode1 := !mode1
	mode2 := false
	UpdateHotkeys()
	ToolTip % "Modus 1: " (mode1 ? "Aktiv" : "Inaktiv")
	SetTimer, RemoveToolTip, -1000
return

F2::
	mode2 := !mode2
	mode1 := false
	UpdateHotkeys()
	ToolTip % "Modus 2: " (mode2 ? "Aktiv" : "Inaktiv")
	SetTimer, RemoveToolTip, -1000
return

RemoveToolTip:
	ToolTip
return

; === TEMPORÄRE DEAKTIVIERUNG ===
~m::HandleTempDisable()
~i::HandleTempDisable()
~j::HandleTempDisable()
~k::HandleTempDisable()
~Ctrl::HandleTempDisable()
~Tab::HandleTempDisable()

~Esc::
	if (tempDeactivated)
	{
		mode1 := savedMode1
		mode2 := savedMode2
		tempDeactivated := false
		UpdateHotkeys()
		ToolTip % "Modi wiederhergestellt"
		SetTimer, RemoveToolTip, -1000
	}
return

HandleTempDisable()
{
	global mode1, mode2, savedMode1, savedMode2, tempDeactivated, rButtonHeld
	if (!tempDeactivated)
	{
		savedMode1 := mode1
		savedMode2 := mode2
		mode1 := false
		mode2 := false
		tempDeactivated := true
		UpdateHotkeys()

		if (rButtonHeld)
		{
			Send, {RButton up}
			rButtonHeld := false
		}

		ToolTip % "Modi deaktiviert"
		SetTimer, RemoveToolTip, -1000
	}
	return
}

; === DYNAMISCH HOTKEYS AKTIVIEREN/DEAKTIVIEREN ===
UpdateHotkeys()
{
	global mode1, mode2
	if (mode1 or mode2)
	{
		Hotkey, *RButton, RButtonHandler, On
		Hotkey, *RButton Up, RButtonUpHandler, On
	}
	else
	{
		Hotkey, *RButton, RButtonHandler, Off
		Hotkey, *RButton Up, RButtonUpHandler, Off
	}
}

; === ZENTRIERUNGSFUNKTION ===
CenterCursor()
{
	SysGet, cx, 78
	SysGet, cy, 79
	MouseMove, cx // 2, cy // 2, 0
}

; === RButton gedrückt ===
RButtonHandler:
	global mode1, mode2, rButtonHeld

	if (mode1)
	{
		if (!rButtonHeld)
		{
			CenterCursor()
			Send, {RButton down}
			rButtonHeld := true
		}
		else
		{
			Send, {RButton up}
			rButtonHeld := false
		}
		return
	}
	else if (mode2)
	{
		if (GetKeyState("RButton", "P"))
		{
			CenterCursor()
			SendInput, {RButton down}
		}
		return
	}
return

; === RButton loslassen ===
RButtonUpHandler:
	global mode2
	if (mode2)
	{
		SendInput, {RButton up}
	}
return

LWin:: ExitApp ; exits the script