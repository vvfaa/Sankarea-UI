-- Sankarea Addon: SaveManager
-- Handles persistent configuration saving for Sankarea UI
-- Based on Fluent's SaveManager with cleaner autosave integration

local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.Folder = "SankareaUI/Configs"
SaveManager.CurrentConfig = nil
SaveManager.Ignore = {}
SaveManager.Library = nil

local function ensureFolder(path)
    if makefolder and not isfolder(path) then
        pcall(makefolder, path)
    end
end

function SaveManager:SetLibrary(lib)
    self.Library = lib
end

function SaveManager:SetFolder(folder)
    self.Folder = folder
    ensureFolder(folder)
end

function SaveManager:IgnoreThemeSettings()
    self.IgnoreTheme = true
end

function SaveManager:SetIgnoreIndexes(tbl)
    self.Ignore = tbl or {}
end

function SaveManager:GetConfigList()
    ensureFolder(self.Folder)
    local list = {}
    if listfiles then
        for _, file in ipairs(listfiles(self.Folder)) do
            if file:sub(-5) == ".json" then
                table.insert(list, file:match("([^/]+)%.json$") or "?")
            end
        end
    end
    return list
end

function SaveManager:Save(name)
    ensureFolder(self.Folder)
    local cfg = {}
    if self.Library and self.Library.Options then
        for key, opt in pairs(self.Library.Options) do
            if not self.Ignore[key] then
                local ok, val = pcall(function() return opt.Value end)
                if ok then cfg[key] = val end
            end
        end
    end
    local raw = HttpService:JSONEncode(cfg)
    pcall(function()
        writefile(self.Folder .. "/" .. name .. ".json", raw)
    end)
    self.CurrentConfig = name
    print("[Sankarea.SaveManager] Saved config:", name)
end

function SaveManager:Load(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    local raw = readfile(path)
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok then return false end
    if self.Library and self.Library.Options then
        for key, val in pairs(data) do
            local opt = self.Library.Options[key]
            if opt and opt.SetValue then
                pcall(opt.SetValue, opt, val)
            end
        end
    end
    self.CurrentConfig = name
    print("[Sankarea.SaveManager] Loaded config:", name)
    return true
end

function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({ Title = "Configuration", Content = "จัดการการบันทึกค่าของ UI ได้ที่นี่" })

    local dropdown = tab:AddDropdown("ConfigSelect", {
        Title = "Select Config",
        Values = self:GetConfigList(),
        Multi = false,
        Default = nil
    })

    dropdown:OnChanged(function(v)
        self.CurrentConfig = v
    end)

    tab:AddButton({
        Title = "Save Config",
        Callback = function()
            if self.CurrentConfig then
                self:Save(self.CurrentConfig)
            else
                local default = "AutoSave"
                self:Save(default)
                dropdown:SetValue(default)
            end
        end
    })

    tab:AddButton({
        Title = "Load Config",
        Callback = function()
            if self.CurrentConfig then
                self:Load(self.CurrentConfig)
            end
        end
    })

    tab:AddButton({
        Title = "Refresh List",
        Callback = function()
            dropdown:SetValues(self:GetConfigList())
        end
    })
end

function SaveManager:LoadAutoloadConfig()
    local auto = self.Folder .. "/autoload.txt"
    if isfile(auto) then
        local name = readfile(auto)
        if name and name ~= "" then
            self:Load(name)
        end
    end
end

function SaveManager:SetAutoload(name)
    if name then
        writefile(self.Folder .. "/autoload.txt", name)
    else
        delfile(self.Folder .. "/autoload.txt")
    end
end

return SaveManager
