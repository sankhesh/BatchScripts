/**
 * AutoHotkey script for volume controls.
 * 
 * Hotkeys:
 *  Win + <F1> - Toggle mute
 *  Win + <F2> - Decrease volume
 *  Win + <F3> - Increase volume
 */

#requires AutoHotkey v2.0

/**
 * Keep a single instance and reload if run again.
 */
#SingleInstance Force

#F1::
  {
    mute := SoundGetMute()
    if (mute)
    {
      SoundSetMute(False)
    }
    else
    {
      SoundSetMute(True)
    }
  }

#F2::SoundSetVolume "-5"

#F3::SoundSetVolume "+5"
