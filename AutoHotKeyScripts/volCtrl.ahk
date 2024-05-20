/**
 * AutoHotkey script for volume controls.
 *
 * Hotkeys:
 *  Win + <F1> - Toggle mute
 *  Win + <F2> - Decrease volume
 *  Win + <F3> - Increase volume
 */

#Requires AutoHotkey v2.0

/**
 * Keep a single instance and reload if run again.
 */
#SingleInstance Force

; The percentage by which to raise or lower the volume each time:
g_Step := 4

; How long to display the volume level bar graphs:
g_DisplayTime := 2000

; Master Volume Bar color (see the help file to use more precise shades):
; g_CBM := "Red"

; Background color:
; g_CW := "Silver"

; Bar's screen position. Use "center" to center the bar in that dimension:
g_PosX := "center"
g_PosY := "center"
g_Width := 150  ; width of bar
g_Thick := 12   ; thickness of bar
; Create the Progress window:
G := Gui("+ToolWindow -Caption -Border +Disabled")
G.MarginX := 0, G.MarginY := 0
opt := "w" g_Width " h" g_Thick ;" background" g_CW
; Master := G.Add("Progress", opt " c" g_CBM)
Master := G.Add("Progress", opt)

; --- Function Definitions ---

HideWindow()
{
    G.Hide()
}

ShowVolume(Value)
{
  Master.Value := Round(Value)
  G.Show("x" g_PosX " y" g_PosY)
  SetTimer HideWindow, -g_DisplayTime
}

ChangeVolume(Prefix, Value)
{
  SoundSetVolume Prefix Value
  ShowVolume(SoundGetVolume())
}

#F1::
{
  mute := SoundGetMute()
  if (mute)
  {
    SoundSetMute(False)
    ShowVolume(SoundGetVolume())
  }
  else
  {
    SoundSetMute(True)
    ShowVolume(0)
  }
}

#F2::
{
  ; SoundSetVolume "-5"
  ChangeVolume "-", g_Step
}

#F3::
{
  ; SoundSetVolume "+5"
  ChangeVolume "+", g_Step
}
