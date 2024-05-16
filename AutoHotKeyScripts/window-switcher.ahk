#Requires AutoHotkey v2.0

/**
 * Keep a single instance and reload if run again.
 */
#SingleInstance Force

; Only works if running as admin. AHK can't interact with admin windows unless it is running as admin...
; if not A_IsAdmin {
;   try {
;     Run "*RunAs " A_ScriptFullPath
;   }
;   MsgBox "Exiting if we cannot run as admin " A_ScriptFullPath
;   ExitApp
; }

; Retrieves the display monitor that has the largest area of intersection with a specified window
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4606
DisplayFromHWND(HWND) {
   Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", 0, "UPtr")
}

; Setup window switching
SetCurrentProgram() {
	global
	local ActiveProgram
	local ActiveDisplay
	ActiveProgram := WinGetProcessName("A")
	ActiveID := WinGetID("A")
	ActiveDisplay := DisplayFromHWND(ActiveID)
	CurrentProgram := "None"
	if (ActiveProgram != CurrentProgram Or ActiveDisplay != CurrentDisplay) {
		if (ActiveProgram = "Explorer.EXE") {
			ProgramArray := WinGetList("ahk_class CabinetWClass")
		}
		else {
			ProgramArray := WinGetList("ahk_exe " ActiveProgram)
		}
		CurrentProgram := ActiveProgram
		CurrentDisplay := ActiveDisplay
		ProgramCursor := 1
	}
}

; Next window
NextProgramWindow() {
	global
	if (ProgramArray.Length > 1) {
		ProgramCursor := ProgramCursor + 1
		if (ProgramCursor > ProgramArray.Length) {
			ProgramCursor := 1
		}
		local CursorID := ProgramArray.Get(ProgramCursor)
		local CursorDisplay := DisplayFromHWND(CursorID)
		if (CurrentDisplay == CursorDisplay) {
			WinActivate "ahk_id " CursorID
		}
		else {
			NextProgramWindow()
		}
	}
}

; Prev window
PrevProgramWindow() {
	global
	if (ProgramArray.Length > 1) {
		ProgramCursor := ProgramCursor - 1
		if (ProgramCursor < 1) {
			ProgramCursor := ProgramArray.Length
		}
		local CursorID := ProgramArray.Get(ProgramCursor)
		local CursorDisplay := DisplayFromHWND(CursorID)
		if (CurrentDisplay == CursorDisplay) {
			WinActivate "ahk_id " CursorID
		}
		else {
			PrevProgramWindow()
		}
	}
}

; Window switcher key bindings

!`::
{
	SetCurrentProgram()
	NextProgramWindow()
	return
}

!+`::
{
	SetCurrentProgram()
	PrevProgramWindow()
	return
}
