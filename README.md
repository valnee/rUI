# rUI
Retro UI is Library for basic UI, for Retro Gagets


# How to use
First, we need get all objects:
```lua
local rUI = require "rUI.lua"
local UIDim = rUI.UIDim -- UIDimensions library
local _Object_Types = rUI._Object_Types
local createObject = rUI.createObject
```

Then, we can do this:
```lua
local VIDEO = gdt.VideoChip0

local screen = createObject(rUI._Object_Types.rUI_SCREEN,
{
	Name="Main",
	Background_Color=color.black,
	Visible=true,
	Video=VIDEO
}, {
	rUI.createObject(_Object_Types.rUI_FRAME,
{	
	Name="frame1", 
	Position=UIDim.new(VIDEO.Width/2, VIDEO.Height/2),
	Size=UIDim.new(10,10), 
	Background_Color=color.yellow, 
	Visible=true 
}, {}),
rUI.createObject(_Object_Types.rUI_LABEL,
{	
	Name="label", -- Name
	Text="Hello World", -- Text
	Font=ROM.System.SpriteSheets["StandardFont"], -- Font
	Position=UIDim.new(50,8), -- Position
	Size=UIDim.new(55,8), -- Size
	Background_Color=color.yellow, -- Background
	Foreground_Color=color.black, -- Foreground
	Visible=true -- Visible
}, {
	
})
})

function update()
	VIDEO:Clear(screen.Background_Color)
	screen:draw()
end
```
And get this result:
![image](https://user-images.githubusercontent.com/121369747/210958596-dee696ac-fa15-4d2b-ad3e-6e0d9f235a73.png)

# Goodluck, i wont show anything more.
