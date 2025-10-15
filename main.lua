-- Sankarea.UI – Xenon Fade Edition
-- Built by Sankarea.gg (based on 666mirp Fluent foundation)

-- ========== Services ==========
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ========== Imports ==========
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/vvfaa/Sankarea-UI/main/Themes/Xenon.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vvfaa/Sankarea-UI/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vvfaa/Sankarea-UI/main/Addons/InterfaceManager.lua"))()

-- ========== Theme & Globals ==========
local Sankarea = {}
Sankarea.Options = {}
Sankarea.Tabs = {}

_G.__SANKAREA_NOTIFY = function(o)
	local Frame = Instance.new("Frame")
	local Text = Instance.new("TextLabel")
	Frame.BackgroundColor3 = Theme.NotifyBG
	Frame.BackgroundTransparency = 0.15
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(0, 280, 0, 65)
	Frame.Position = UDim2.new(1, 300, 1, -90)
	Frame.AnchorPoint = Vector2.new(1, 1)
	Frame.Parent = CoreGui

	Text.BackgroundTransparency = 1
	Text.Font = Enum.Font.FredokaOne
	Text.Text = string.format("%s\n%s", o.Title or "Sankarea", o.Content or "")
	Text.TextSize = 18
	Text.TextColor3 = Theme.Text
	Text.TextWrapped = true
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.Size = UDim2.new(1, -24, 1, -12)
	Text.Position = UDim2.new(0, 12, 0, 0)
	Text.Parent = Frame

	-- fade in
	Frame.Position = UDim2.new(1, 300, 1, -90)
	TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -20, 1, -90)
	}):Play()

	task.delay(o.Duration or 3.5, function()
		TweenService:Create(Frame, TweenInfo.new(0.4), {Position = UDim2.new(1, 300, 1, -90), BackgroundTransparency = 1}):Play()
		task.wait(0.4)
		Frame:Destroy()
	end)
end

-- ========== Window ==========
function Sankarea:CreateWindow(cfg)
	cfg = cfg or {}
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SankareaUI"
	ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	-- Base Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.BackgroundColor3 = Theme.WindowBG
	MainFrame.Size = UDim2.new(0, 640, 0, 420)
	MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true
	MainFrame.BorderSizePixel = 0
	MainFrame.BackgroundTransparency = 0.12

	-- topbar
	local Header = Instance.new("TextLabel")
	Header.Size = UDim2.new(1, 0, 0, 38)
	Header.BackgroundTransparency = 1
	Header.Text = "Anime Eternal • Sankarea.gg"
	Header.Font = Enum.Font.FredokaOne
	Header.TextSize = 26
	Header.TextColor3 = Theme.Accent
	Header.Parent = MainFrame

	-- underline glow
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -20, 0, 1)
	line.Position = UDim2.new(0, 10, 0, 37)
	line.BackgroundColor3 = Theme.Accent
	line.BorderSizePixel = 0
	line.Parent = MainFrame
	TweenService:Create(line, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
		BackgroundTransparency = 0.6
	}):Play()

	Sankarea._root = MainFrame
	return Sankarea
end
-- ========== Tab System ==========
function Sankarea:AddTab(tabData)
	local Tab = {}
	tabData = tabData or {}
	local title = tabData.Title or "Untitled"

	local Sidebar = self._root:FindFirstChild("Sidebar")
	if not Sidebar then
		Sidebar = Instance.new("Frame")
		Sidebar.Name = "Sidebar"
		Sidebar.Parent = self._root
		Sidebar.BackgroundColor3 = Theme.Sidebar
		Sidebar.BorderSizePixel = 0
		Sidebar.Size = UDim2.new(0, 160, 1, -38)
		Sidebar.Position = UDim2.new(0, 0, 0, 38)
	end

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, 0, 0, 36)
	Button.BackgroundTransparency = 1
	Button.Text = " " .. title
	Button.Font = Enum.Font.FredokaOne
	Button.TextColor3 = Theme.SubText
	Button.TextSize = 18
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.Parent = Sidebar

	local Line = Instance.new("Frame")
	Line.BackgroundColor3 = Theme.Accent
	Line.BorderSizePixel = 0
	Line.Size = UDim2.new(0, 3, 1, 0)
	Line.Position = UDim2.new(0, 0, 0, 0)
	Line.Visible = false
	Line.Parent = Button

	local Page = Instance.new("Frame")
	Page.Visible = false
	Page.Size = UDim2.new(1, -160, 1, -38)
	Page.Position = UDim2.new(0, 160, 0, 38)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.Parent = self._root

	Tab.Page = Page
	Tab.Button = Button
	self.Tabs[title] = Tab

	Button.MouseEnter:Connect(function()
		if not Page.Visible then
			TweenService:Create(Button, TweenInfo.new(0.15), {TextColor3 = Theme.Accent}):Play()
		end
	end)

	Button.MouseLeave:Connect(function()
		if not Page.Visible then
			TweenService:Create(Button, TweenInfo.new(0.15), {TextColor3 = Theme.SubText}):Play()
		end
	end)

	Button.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Page.Visible = false
			tab.Button.TextColor3 = Theme.SubText
			tab.Button:FindFirstChildOfClass("Frame").Visible = false
		end
		Page.Visible = true
		Button.TextColor3 = Theme.Accent
		Line.Visible = true

		Page.BackgroundTransparency = 1
		TweenService:Create(Page, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0
		}):Play()
	end)

	return Tab
end

-- ========== Example Tabs ==========
function Sankarea:InitDefaultTabs()
	local tMain = self:AddTab({ Title = "Main" })
	local tUpg = self:AddTab({ Title = "Upgrade" })
	local tRoll = self:AddTab({ Title = "Roll" })
	local tClaim = self:AddTab({ Title = "Claim" })
	local tSettings = self:AddTab({ Title = "Settings" })

	-- preview label inside each
	for _, tab in pairs(self.Tabs) do
		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.FredokaOne
		lbl.TextColor3 = Theme.Text
		lbl.TextSize = 22
		lbl.Text = tab.Button.Text
		lbl.Size = UDim2.new(1, -40, 0, 50)
		lbl.Position = UDim2.new(0, 20, 0, 20)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = tab.Page
	end

	-- auto select Main
	task.wait(0.1)
	for _, t in pairs(self.Tabs) do t.Page.Visible = false end
	self.Tabs["Main"].Page.Visible = true
	self.Tabs["Main"].Button.TextColor3 = Theme.Accent
	self.Tabs["Main"].Button:FindFirstChildOfClass("Frame").Visible = true
end
-- ========== Controls ==========
function Sankarea:AddToggle(tabTitle, data)
	local tab = self.Tabs[tabTitle]
	if not tab then return end
	data = data or {}

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -40, 0, 40)
	holder.Position = UDim2.new(0, 20, 0, (#tab.Page:GetChildren() - 1) * 45 + 60)
	holder.BackgroundColor3 = Theme.Card
	holder.BorderSizePixel = 0
	holder.Parent = tab.Page

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Text = data.Title or "Toggle"
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 20
	title.TextColor3 = Theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 10, 0, 0)
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Parent = holder

	local btn = Instance.new("TextButton")
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.Position = UDim2.new(1, -10, 0.5, 0)
	btn.Size = UDim2.new(0, 48, 0, 24)
	btn.BackgroundColor3 = Theme.ToggleOff
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.Parent = holder

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 20, 0, 20)
	dot.Position = UDim2.new(0, 2, 0.5, -10)
	dot.BackgroundColor3 = Theme.ToggleDot
	dot.BorderSizePixel = 0
	dot.Parent = btn

	local on = data.Default or false
	local function setToggle(state)
		on = state
		if on then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOn}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
		else
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOff}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
		end
		if data.Callback then
			task.spawn(function() data.Callback(on) end)
		end
	end
	setToggle(on)

	btn.MouseButton1Click:Connect(function()
		setToggle(not on)
	end)
end

function Sankarea:AddSlider(tabTitle, data)
	local tab = self.Tabs[tabTitle]
	if not tab then return end
	data = data or {}
	local min, max = data.Min or 1, data.Max or 100
	local val = data.Default or min

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -40, 0, 50)
	holder.Position = UDim2.new(0, 20, 0, (#tab.Page:GetChildren() - 1) * 55 + 60)
	holder.BackgroundColor3 = Theme.Card
	holder.BorderSizePixel = 0
	holder.Parent = tab.Page

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Text = string.format("%s: %d", data.Title or "Slider", val)
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 20
	title.TextColor3 = Theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Parent = holder

	local bar = Instance.new("Frame")
	bar.BackgroundColor3 = Theme.SliderBG
	bar.BorderSizePixel = 0
	bar.Position = UDim2.new(0, 10, 0, 35)
	bar.Size = UDim2.new(1, -20, 0, 5)
	bar.Parent = holder

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
	fill.Parent = bar

	local dragging = false
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	bar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			val = math.floor(min + (max - min) * rel + 0.5)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			title.Text = string.format("%s: %d", data.Title or "Slider", val)
			if data.Callback then data.Callback(val) end
		end
	end)
end

