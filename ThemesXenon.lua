-- Sankarea.UI Theme: Xenon
-- Author: 666mirp (for Anime Eternal)
-- Style: Smooth Gradient + FredokaOne font + Subtle Blur + Soft Fade

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local XenonTheme = {}

-- 🎨 Base Colors (Xenon look)
XenonTheme.Colors = {
    Background = Color3.fromRGB(18, 18, 22),
    Panel      = Color3.fromRGB(26, 26, 32),
    Card       = Color3.fromRGB(32, 32, 40),
    Accent     = Color3.fromRGB(255, 95, 150),
    Text       = Color3.fromRGB(235, 235, 245),
    SubText    = Color3.fromRGB(170, 170, 190),
    ToggleOn   = Color3.fromRGB(50, 220, 140),
    Shadow     = Color3.fromRGB(0, 0, 0),
    GradientA  = Color3.fromRGB(255, 130, 180),
    GradientB  = Color3.fromRGB(130, 110, 255),
}

-- 🧊 Blur Layer (soft + dynamic)
XenonTheme.Blur = function()
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    TweenService:Create(blur, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Size = 18 }):Play()
    return blur
end

-- ✨ Soft fade-in for UI
XenonTheme.FadeIn = function(ui)
    if not ui or not ui:IsA("GuiObject") then return end
    ui.BackgroundTransparency = 1
    for _, obj in pairs(ui:GetDescendants()) do
        if obj:IsA("GuiObject") then obj.BackgroundTransparency = 1 end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextTransparency = 1 end
    end
    task.wait()
    for _, obj in pairs(ui:GetDescendants()) do
        local tweenProps = {}
        if obj:IsA("GuiObject") then tweenProps.BackgroundTransparency = 0 end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then tweenProps.TextTransparency = 0 end
        TweenService:Create(obj, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tweenProps):Play()
    end
end

-- 🔔 Notify (bottom right)
XenonTheme.Notify = function(msg)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SankareaNotify"
    ScreenGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.Position = UDim2.new(1, -20, 1, -20)
    frame.Size = UDim2.new(0, 320, 0, 80)
    frame.BackgroundColor3 = XenonTheme.Colors.Card
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = ScreenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = XenonTheme.Colors.Accent
    uiStroke.Thickness = 1
    uiStroke.Transparency = 0.5
    uiStroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 18
    label.TextColor3 = XenonTheme.Colors.Text
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 16, 0, 10)
    label.Size = UDim2.new(1, -32, 1, -20)
    label.Text = msg or "Notification"
    label.Parent = frame

    frame.Position = UDim2.new(1, 340, 1, -20)
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, 1, -20)
    }):Play()

    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 340, 1, -20)
        }):Play()
        task.wait(0.6)
        ScreenGui:Destroy()
    end)
end

-- 🌈 Gradient bar (optional aesthetic)
XenonTheme.AddGradient = function(obj)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, XenonTheme.Colors.GradientA),
        ColorSequenceKeypoint.new(1, XenonTheme.Colors.GradientB)
    })
    grad.Rotation = 45
    grad.Parent = obj
end

return XenonTheme
