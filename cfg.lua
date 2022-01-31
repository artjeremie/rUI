ruiDB = {}

local rui = CreateFrame("Frame")
rui:RegisterEvent("PLAYER_LOGIN")
rui:SetScript("OnEvent", function(self, event)

    local defaults = {
        A_GREETINGS = true,
        A_ARTWORK = true,
        A_AUTOADDSPELL = true,
        A_EXTRABAR = true,
        A_ALERTS = true,
        A_PLATESHORT = true,
        A_PRDRESOURCE = true,
        A_STOPWATCH = true,
        A_TALKINGHEAD = true,
        A_TOOLTIP = true,
        A_UNITFRAMES = true,

        PLATESHORT = {
            W = 70,
            H = 20,
        },
        TOOLTIP = {
            X = -480,
            Y = -360,
            MOUSE = false,
        },
    }

    --  Copy defaults
    local function ruiCopyDefaults(src, dst)
        if type(src) ~= "table" then return {} end
        if type(dst) ~= "table" then dst = { } end
        for k, v in pairs(src) do
            if type(v) == "table" then
                dst[k] = ruiCopyDefaults(v, dst[k])
            elseif type(v) ~= type(dst[k]) then
                dst[k] = v
            end
        end
        return dst
    end

    ruiDB = ruiCopyDefaults(defaults, ruiDB)

    if ruiDB.A_DEFAULTS == nil then
        StaticPopupDialogs["INSTALL"] = {
            text = "Welcome to rui",
            button1 = "Install",
            OnAccept = function()
                ruiDB.A_DEFAULTS = true
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3
        }
        StaticPopup_Show("INSTALL")
    end
end)

--  Configuration frame function
local function ruiCreateConfig()
    --  Frame
    local ruiConfig = CreateFrame("Frame", "ruiConfig", UIParent, "ButtonFrameTemplate")
    SetPortraitToTexture(ruiConfig.portrait, "Interface\\Icons\\Temp")
    ruiConfig:SetSize(450, 525)
    ruiConfig:SetPoint("CENTER")
    ruiConfig:SetClampedToScreen(true)
    ruiConfig:EnableMouse(true)
    ruiConfig:SetMovable(true)
    ruiConfig:RegisterForDrag("LeftButton")
    ruiConfig:SetScript("OnDragStart", function(self)self:StartMoving()end)
    ruiConfig:SetScript("OnDragStop", function(self)self:StopMovingOrSizing()end)
    ruiConfig:Hide()

    local ruiConfigTitle = ruiConfig:CreateFontString(nil, ruiConfig, "GameFontNormalLarge")
    ruiConfigTitle:SetPoint("TOP", 0, -32)
    ruiConfigTitle:SetText("rUI Options")

    --  Colors
    for i, v in pairs({
        ruiConfigBg,
        ruiConfigTitleBg
    }) do
    v:SetVertexColor(.40, .40, .40)
end

for i, v in pairs({
    ruiConfigPortraitFrame,
    ruiConfig.NineSlice.TopEdge,
    ruiConfig.NineSlice.BottomEdge,
    ruiConfig.NineSlice.RightEdge,
    ruiConfig.NineSlice.LeftEdge,
    ruiConfig.NineSlice.TopLeftCorner,
    ruiConfig.NineSlice.BottomLeftCorner,
    ruiConfig.NineSlice.TopRightCorner,
    ruiConfig.NineSlice.BottomRightCorner,
}) do
v:SetVertexColor(.30, .30, .30) end end

ruiCreateConfig()

--  Show configuration function
local function ruiConfigShow()
    --  Backdrop
    local backdrop = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
    }

    --  Popups function
    local function HELP()
        StaticPopupDialogs["HELP"] = {
            text = "Pls report Errors/Bugs/Issues on Curseforge.com/wow/addons/rui",
            button1 = "Close",
            button2 = "Reset UI",
            OnAccept = function()
                ruiConfigShow()
            end,
            OnCancel = function()
                ruiDB = nil
                ReloadUI()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3
        }
        StaticPopup_Show("HELP")
    end

    --  Buttons function
    local function ruiCreateBTN(text,point1,anchor,point2,pos1,pos2,width,height)
        ruiButton = CreateFrame("Button", nil, ruiConfig, "UIPanelButtonTemplate")
        ruiButton:SetPoint(point1, anchor, point2, pos1, pos2)
        ruiButton:SetWidth(width)
        ruiButton:SetHeight(height)
        ruiButton:SetText(text)
    end

    --  Text function
    local function ruiCreateTXT(text,anchor,point,pos1,pos2, ...)
        ruiTXT = ruiConfig:CreateFontString(nil, ruiConfig, "GameFontNormalLarge")
        ruiTXT:SetPoint(point, anchor, pos1, pos2)
        ruiTXT:SetText(text)
    end

    --  Checkbox function
    local function ruiCreateCB(name,anchor,tooltip,db, ...)
        ruiCB = CreateFrame("CheckButton", nil, ruiConfig, "OptionsBaseCheckButtonTemplate")
        ruiCB:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -5)

        ruiCB:SetScript("OnClick", function(frame)
            local tick = frame:GetChecked()
            ruiDB[db] = tick
            if tick then
                DEFAULT_CHAT_FRAME:AddMessage(name .. " Enabled", 0, 1, 0)
                ruiDB[db] = true
            else
                DEFAULT_CHAT_FRAME:AddMessage(name .. " Disabled", 1, 0, 0)
                ruiDB[db] = false
            end
        end)

        ruiCB:SetScript("OnShow", function(frame)
            frame:SetChecked(ruiDB[db])
        end)

        ruiCB:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(tooltip, 248, 248, 255)
            GameTooltip:Show()
        end)

        ruiCB:SetScript("OnLeave", GameTooltip_Hide)
        text = ruiConfig:CreateFontString(nil, ruiConfig, "GameFontHighlight")
        text:SetPoint("LEFT", ruiCB, "RIGHT", 0, 1)
        text:SetText(name)
    end

    --  Buttons
    ruiCreateBTN("Save & Reload", "BOTTOMLEFT", ruiConfig, "BOTTOMLEFT", 16, 35, 100, 25)
    ruiButton:SetScript("OnClick", function(self, button, down)
        ReloadUI()
    end)

    ruiCreateBTN("Help & Reset", "BOTTOMLEFT", ruiConfig, "BOTTOMLEFT", 120, 35, 100, 25)
    ruiButton:SetScript("OnClick", function(self, button, down)
        ruiConfig:Hide()
        HELP()
    end)

    --  UI
    ruiCreateTXT("UI", ruiConfig, "TOPLEFT", 20, -75)

    --  Space
    ruiCreateTXT("", ruiConfig, "TOPLEFT", 20, -90)

    --  Layout A
    ruiCreateCB("Actionbar", ruiTXT, "Hide actionbar artwork", "A_ARTWORK")
    ruiCreateCB("Unitframe", ruiCB, "Minimal unitframe", "A_UNITFRAMES")
    ruiCreateCB("Nameplates", ruiCB, "Friendly nameplate short", "A_PLATESHORT")
    ruiCreateCB("Personal Resource Display", ruiCB, "Prd resource large", "A_PRDRESOURCE")
    ruiCreateCB("Auto Add Spell", ruiCB, "Disable auto add spell in actionbar", "A_AUTOADDSPELL")
    ruiCreateCB("Extrabar", ruiCB, "Hide extrabar artwork", "A_EXTRABAR")
    ruiCreateCB("Alerts", ruiCB, "Hide red text alerts", "A_ALERTS")

    --  Space
    ruiCreateTXT("", ruiTXT, "CENTER", 150, 0)

    --  MISC
    ruiCreateTXT("MISC", ruiConfig, "TOPLEFT", 20, -315)

    --  Space
    ruiCreateTXT("", ruiConfig, "TOPLEFT", 20, -330)

    --  LAYOUT B
    ruiCreateCB("Greetings", ruiTXT, "Disable login greetings", "A_GREETINGS")
    ruiCreateCB("Stopwatch", ruiCB, "Auto start stopwatch", "A_STOPWATCH")
    ruiCreateCB("Talkinghead", ruiCB, "Disable talkinghead but retain audio", "A_TALKINGHEAD")

    ruiConfig:Show()
end

local activ = false
function openrui()
    if activ == false then
        ruiConfigShow()
        activ = true
    else
        ruiConfig:Show()
    end
end

GameMenuFrame.Header:Hide()
local frame = CreateFrame("Button","UIPanelButtonTemplateTest", GameMenuFrame, "UIPanelButtonTemplate")
frame:SetHeight(20)
frame:SetWidth(145)
frame:SetText("|cfff58cbar|r|cff009cffUI|r")
frame:ClearAllPoints()
frame:SetPoint("TOP", 0, -11)
frame:RegisterForClicks("AnyUp")
frame:SetScript("OnClick", function()
    openrui()
    ToggleGameMenu();
end)
SlashCmdList["rui"] = function() openrui() end
SLASH_rui1 = "/rui"
