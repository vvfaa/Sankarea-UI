-- Sankarea.UI Main
-- Rebuilt Fluent-style UI using Xenon Theme & Addons by 666mirp (Sankarea Edition)

-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Imports
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sankarea/UI/main/Themes/Xenon.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sankarea/UI/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sankarea/UI/main/Addons/InterfaceManager.lua"))()

-- ================== Core UI ==================
local Sankarea = {}
Sankarea.Options = {}
Sankarea.Tabs = {}
Sankarea._root = nil

-- Root window
function Sankarea:CreateWindow(cfg)
    cfg = cfg or {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SankareaUI"
    ScreenGui.Parent = CoreGui
    self._root = ScreenGui

    -- Base frame
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Size = cfg.Size or UDim2.fromOffset(640, 480)
    Frame.Position = UDim2.new(0.5, -320, 0.5, -240)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Theme.Colors.Panel
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    -- Rounded corners
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    -- Drop shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.ZIndex = 0
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 48, 1, 48)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageTransparency = 0.75
    Shadow.ImageColor3 = Theme.Colors.Shadow
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = Frame

    -- Title bar
    local Title = Instance.new("TextLabel")
    Title.Text = cfg.Title or "Anime Eternal • Sankarea.gg"
    Title.Font = Enum.Font.FredokaOne
    Title.TextColor3 = Theme.Colors.Text
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Parent = Frame

    -- Gradient accent line
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, 0, 0, 2)
    Accent.Position = UDim2.new(0, 0, 0, 50)
    Accent.BackgroundTransparency = 0
    Theme.AddGradient(Accent)
    Accent.Parent = Frame

    -- Tabs container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Frame

    Theme.FadeIn(Frame)
    return self
end

function Sankarea:AddTab(info)
    info = info or {}
    local tab = { Title = info.Title or "Tab", Options = {} }
    self.Tabs[tab.Title] = tab
    return tab
end

function Sankarea:AddToggle(name, data)
    local toggle = Instance.new("BoolValue")
    toggle.Value = data.Default or false
    toggle.Name = name
    self.Options[name] = { Type = "Toggle", Value = toggle.Value, SetValue = function(_, v)
        toggle.Value = v
    end }
    return {
        OnChanged = function(_, fn)
            toggle.Changed:Connect(fn)
        end
    }
end

function Sankarea:AddSlider(name, data)
    local slider = Instance.new("NumberValue")
    slider.Value = data.Default or 0
    slider.Name = name
    self.Options[name] = { Type = "Slider", Value = slider.Value, SetValue = function(_, v)
        slider.Value = v
    end }
    return {
        OnChanged = function(_, fn)
            slider.Changed:Connect(fn)
        end
    }
end

function Sankarea:AddButton(data)
    local btn = Instance.new("BindableEvent")
    btn.Name = data.Title
    btn.Event:Connect(data.Callback or function() end)
    return btn
end

function Sankarea:AddParagraph(info)
    print("[Sankarea.UI] Paragraph:", info.Title or "")
end

function Sankarea:Notify(o)
    Theme.Notify(o.Content or "Notification")
end

function Sankarea:GetRoot()
    return self._root
end

-- Accent ping (for InterfaceManager)
function Sankarea:_accentPing()
    self:Notify({ Content = "Accent color: Xenon 💜", Duration = 1.5 })
end

-- ================ Initialize Addons =================
SaveManager:SetLibrary(Sankarea)
SaveManager:SetFolder("SankareaUI/Configs")

InterfaceManager:SetLibrary(Sankarea)
InterfaceManager:SetFolder("SankareaUI")
InterfaceManager:SetTheme(Theme)

-- Example window (like test run)
local Window = Sankarea:CreateWindow({
    Title = "Anime Eternal • Sankarea.gg",
    Size = UDim2.fromOffset(640, 480)
})

local Main = Sankarea:AddTab({ Title = "Main" })
local Settings = Sankarea:AddTab({ Title = "Settings" })

-- Demo UI
local Toggle = Sankarea:AddToggle("AutoMode", { Title = "Auto Mode", Default = false })
Toggle:OnChanged(function(v)
    Sankarea:Notify({ Content = "Auto Mode: " .. tostring(v) })
end)

local Slider = Sankarea:AddSlider("Speed", { Title = "Speed", Default = 10, Min = 1, Max = 50 })
Slider:OnChanged(function(v)
    Sankarea:Notify({ Content = "Speed set to " .. tostring(v) })
end)

Sankarea:AddButton({
    Title = "Show Notify",
    Callback = function()
        Sankarea:Notify({ Content = "Hello from Sankarea ✨" })
    end
})

Sankarea:AddParagraph({ Title = "Welcome", Content = "UI Theme: Xenon — Clean, Fredoka, Soft blur" })

-- Hook addons
InterfaceManager:BuildInterfaceSection(Settings)
SaveManager:BuildConfigSection(Settings)
SaveManager:LoadAutoloadConfig()

return Sankarea
