-- Sankarea Addon: InterfaceManager
-- Build settings section (blur toggle, theme hooks) for Sankarea UI
-- Works with Sankarea Fluent Library (expects :GetRoot()) and a Theme table (expects .Blur())

local InterfaceManager = {}

InterfaceManager.Library = nil
InterfaceManager.Folder  = "SankareaUI"
InterfaceManager.Theme   = nil

-- internal
local BlurInstance = nil
local BlurEnabled  = true

-- ===== Public API =====
function InterfaceManager:SetLibrary(lib)
    self.Library = lib
end

function InterfaceManager:SetFolder(folder)
    self.Folder = folder or self.Folder
end

-- Inject active theme (from Themes/Xenon.lua)
function InterfaceManager:SetTheme(theme)
    self.Theme = theme
end

-- Toggle Blur on/off
function InterfaceManager:_applyBlur(on)
    BlurEnabled = on and true or false
    if BlurEnabled then
        -- create blur if not exists
        if not BlurInstance and self.Theme and self.Theme.Blur then
            local ok, blur = pcall(self.Theme.Blur)
            if ok and blur then
                BlurInstance = blur
            end
        end
    else
        -- remove blur
        if BlurInstance and BlurInstance.Parent then
            BlurInstance.Size = 0
            BlurInstance:Destroy()
        end
        BlurInstance = nil
    end
end

-- Optional: apply FredokaOne to all current text
local function applyFredokaToAll(root)
    if not root or not root.GetDescendants then return end
    for _, obj in pairs(root:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() obj.Font = Enum.Font.FredokaOne end)
        end
    end
end

-- Build settings UI section inside provided tab
function InterfaceManager:BuildInterfaceSection(tab)
    -- Defensive checks
    if not tab or type(tab.AddToggle) ~= "function" then
        warn("[Sankarea.InterfaceManager] invalid tab; expected Sankarea Fluent tab object")
        return
    end

    tab:AddParagraph({
        Title = "Interface",
        Content = "ตั้งค่าหน้าตา UI ของ Sankarea ได้ตรงนี้"
    })

    -- Blur Toggle
    local BlurToggle = tab:AddToggle("UI_Blur", {
        Title = "Enable Blur (soft)",
        Default = true
    })
    BlurToggle:OnChanged(function(on)
        self:_applyBlur(on)
        if self.Library and self.Library.Notify then
            self.Library:Notify({ Content = on and "Blur: ON" or "Blur: OFF", Duration = 2 })
        end
    end)

    -- Apply font button (in case theme was reset by other libs)
    tab:AddButton({
        Title = "Re-apply Fredoka Font",
        Callback = function()
            local root = self.Library and self.Library:GetRoot()
            if root then
                applyFredokaToAll(root)
                if self.Library and self.Library.Notify then
                    self.Library:Notify({ Content = "Applied FredokaOne to all UI text.", Duration = 2.5 })
                end
            end
        end
    })

    -- Accent ping (visual check)
    tab:AddButton({
        Title = "Accent Ping",
        Callback = function()
            if self.Library and self.Library._accentPing then
                self.Library:_accentPing()
            elseif self.Library and self.Library.Notify then
                self.Library:Notify({ Content = "Accent ping ✨", Duration = 1.5 })
            end
        end
    })

    -- Initialize with default blur state after UI mounts
    task.defer(function()
        self:_applyBlur(true)
        local root = self.Library and self.Library:GetRoot()
        if root then
            applyFredokaToAll(root)
        end
    end)
end

return InterfaceManager
