-- retroUI. Valne.

-- Export types
-- UIDim (UIDimensions)
export type UIDim = {x : number, y : number}

-- Object
export type rUI_Object = {
	-- Basic
	Name : string,
	Type : string,
	Size : UIDim,
	Position : UIDim,
	Background_Color : color,
	Foreground_Color : color,
	Visible : boolean,
	Children : any,
	Parent : any,
	Video : VideoChip,
	-- Functions
	new : any,
	draw : any,
	update : any,
}

local _Object_Types = {
	rUI_NULL = "rUI_NULL",
	rUI_SCREEN = "rUI_SCREEN",
	rUI_FRAME = "rUI_FRAME",
	rUI_LABEL = "rUI_LABEL",
}

-- Variables

local function CLOCK() return gdt.CPU0.Time end

-- Things

local UIDim = {}
function UIDim.new(x : number, y : number) : UIDim
	return setmetatable({X=x,Y=y}, {__index = UIDim}) :: any
end

local Object = {}

function Object.new(Name : string, Position : UIDim, Size : UIDim, Background_Color : color,
					Foreground_Color : color, Visible : boolean, Children, Parent, Video : VideoChip)
	local self = setmetatable({}, {__index = Object})
	self.Name = Name
	self.Type = _Object_Types.rUI_NULL
	self.Position = Position
	self.Size = Size
	self.Background_Color = Background_Color
	self.Foreground_Color = Foreground_Color
	self.Visible = Visible
	self.Children = Children
	self.Parent = Parent
	self.Video = Video

	return self :: any
end

function Object:draw()
	print(self.Name .. "drawing.")
end

function Object:update()
	print(self.Name .. "updating")
end

function Object:add_child(object : rUI_Object)
	if not self.Children then return end
	self.Children[object.Name] = object
	object.Parent = self
	return object
end


local Screen = {}

function Screen.new(Name : string,  Background_Color : color, Visible : boolean, Video : VideoChip) : rUI_Object
	local self = setmetatable({}, {__index = Screen})
	self.Name = Name
	self.Type = _Object_Types.rUI_SCREEN
	self.Background_Color = Background_Color
	self.Visible = Visible
	self.Children = {}

	self.DeltaTime = 0
	self.Video = Video

	return self :: any
end

function Screen:draw()
	if not self.Visible then return end
	for i, child in pairs(self.Children) do
		if child.Type == _Object_Types.rUI_FRAME then
			child:draw(self.Video)
		end
	end

	for i, child in pairs(self.Children) do
		if child.Type == _Object_Types.rUI_LABEL then
			child:draw(self.Video)
		end
	end

	--[[
	for i, child in pairs(self.Children) do
		if child.Type == _Object_Types.rUI_BUTTON then

		end
	end
	]]
end

function Screen:update()
	self.Video:Clear(self.Background_Color)
	local T1 = CLOCK()

	for i, child in pairs(self.Children) do
		child:_update(self.DeltaTime)
	end
	self:draw()

	self.DeltaTime = CLOCK() - T1
end

function Screen:add_child(object : rUI_Object)
	if not self.Children then return end
	self.Children[object.Name] = object
	object.Parent = self
	return object
end

local Frame = {}

function Frame.new(Name : string, Position : UIDim, Size : UIDim, Background_Color : color, Visible : boolean) : rUI_Object
	local self = setmetatable({}, {__index = Frame})
	self.Name = Name
	self.Type = _Object_Types.rUI_FRAME
	self.Position = Position
	self.Size = Size
	self.Background_Color = Background_Color
	self.Visible = Visible
	self.Children = {}
	self.Parent = nil

	self.onHover = function()

	end

	self.update = function(dt)

	end

	return self :: any
end

function Frame:isInside(x,y)
	local TopLeft = vec2(
		self.Position.X - self.Size.X/2,
		self.Position.Y - self.Size.Y/2
	)
	local BottomRight = vec2(
		self.Position.X + self.Size.X/2,
		self.Position.Y + self.Size.Y/2
	)
	if x >= TopLeft.X and x <= BottomRight.X and
		y >= TopLeft.Y and y <= BottomRight.Y
	then
		return true
	end
	return false
end

function Frame:draw(video : VideoChip)
	if not self.Visible then return end
	local TopLeft = vec2(
		self.Position.X - self.Size.X/2,
		self.Position.Y - self.Size.Y/2
	)
	local BottomRight = vec2(
		self.Position.X + self.Size.X/2,
		self.Position.Y + self.Size.Y/2
	)
	video:FillRect(TopLeft, BottomRight, self.Background_Color)
end

function Frame:_update(dt)
	
end

function Frame:add_child(object : rUI_Object)
	if not self.Children then return end
	self.Children[object.Name] = object
	object.Parent = self
	return object
end

local Label = {}

function Label.new(Name : string, Text: string, Font : any, Position : UIDim, Size : UIDim,
					Background_Color : color, Foreground_Color : color, Visible : boolean) : rUI_Object
	local self = setmetatable({}, {__index = Label})
	self.Type = _Object_Types.rUI_LABEL
	self.Name = Name
	self.Text = Text
	self.Font = Font
	self.Size = Size
	self.Position = Position
	self.Background_Color = Background_Color
	self.Foreground_Color = Foreground_Color
	self.Visible = Visible
	self.Parent = nil

	self.onHover = function()

	end

	self.update = function(dt)

	end

	return self :: any
end

function Label:isInside(x,y)
	local TopLeft = vec2(
		self.Position.X - self.Size.X/2,
		self.Position.Y - self.Size.Y/2
	)
	local BottomRight = vec2(
		self.Position.X + self.Size.X/2,
		self.Position.Y + self.Size.Y/2
	)
	if x >= TopLeft.X and x <= BottomRight.X and
		y >= TopLeft.Y and y <= BottomRight.Y
	then
		return true
	end
	return false
end

function Label:draw(video : VideoChip)
	if not self.Visible then return end
	local TopLeft = vec2(
		self.Position.X - self.Size.X/2,
		self.Position.Y - self.Size.Y/2
	)
	local BottomRight = vec2(
		self.Position.X + self.Size.X/2,
		self.Position.Y + self.Size.Y/2
	)
	video:FillRect(TopLeft, BottomRight, self.Background_Color)
	video:DrawText(TopLeft, self.Font, self.Text, self.Foreground_Color, color.clear)
end

function Label:add_child(object : rUI_Object)
	if not self.Children then return end
	self.Children[object.Name] = object
	object.Parent = self
	return object
end


local function createObject(Type, Param, Children)
	local ParentObject

	if Type == _Object_Types.rUI_SCREEN then
		ParentObject = Screen.new(Param.Name, Param.Background_Color,
								Param.Visible, Param.Video)
	end
	if Type == _Object_Types.rUI_FRAME then
		ParentObject = Frame.new(Param.Name, Param.Position,  Param.Background_Color, Param.Visible)
	end
	if Type == _Object_Types.rUI_LABEL then
		--Name : string, Text: string, Font : any, Position : UIDim, Size : UIDim,
		--Background_Color : color, Foreground_Color : color, Visible : boolean) : rUI_Object
		ParentObject = Label.new(Param.Name, Param.Text, Param.Font, Param.Position, Param.Size,Param.Background_Color, Param.Foreground_Color, Param.Visible)
	end

	for i, child in pairs(Children) do
		ParentObject:add_child(child)
	end

	return ParentObject
end

return {
	_Object = Object,
	_Object_Types = _Object_Types,
	UIDim = UIDim,
	Screen = Screen,
	Frame = Frame,
	Label = Label,
	createObject = createObject
}
