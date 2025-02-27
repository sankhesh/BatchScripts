/**
 * AutoHotkey script for volume controls.
 *
 * Hotkeys:
 *  Win + 0							- Switch to LG monitor
 *  Win + <Shift> + 0		- Switch to Samsung monitor
 */

#Requires AutoHotkey v2.0

/**
 * Keep a single instance and reload if run again.
 */
#SingleInstance Force


#0::
{
	Run 'DisplaySwitch.exe /internal'
}

#+0::
{
	Run 'DisplaySwitch.exe /external'
}
