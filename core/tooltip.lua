local rui = CreateFrame("Frame")
local xyx = true
rui:RegisterEvent("PLAYER_LOGIN")
rui:SetScript("OnEvent", function(self, event)

  if not ruiDB.A_TOOLTIP == true then return end

  FONT = STANDARD_TEXT_FONT
  local classColorHex, factionColorHex = {}, {}

  --  Configuration
  local cfg = {
    pos = {"TOP", UIParent, "TOPRIGHT", ruiDB.TOOLTIP.X, ruiDB.TOOLTIP.Y},
    textColor = {255,255,255},
    boossColor = {1,0,0},
    eliteColor = {1,0,0.5},
    rareeliteColor = {1,0.5,0},
    rareColor = {1,0.5,0},
    levelColor = {0.8,0.8,0.5},
    deadColor = {0.5,0.5,0.5},
    targetColor = {1,0.5,0.5},
    guildColor = {0.8, 0.0, 0.6},
    afkColor = {0,1,1},
    scale = 0.95,
    fontFamily = STANDARD_TEXT_FONT,
    backdrop = {
      bgFile = "Interface\\Buttons\\WHITE8x8",
      bgColor = {0.03,0.03,0.03, 0.9},
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      borderColor = {0.03,0.03,0.03, 0.9},
      itemBorderColorAlpha = 0.9,
      azeriteBorderColor = {1,0.3,0,0.9},
      tile = false,
      tileEdge = false,
      tileSize = 16,
      edgeSize = 16,
      insets = {left=3, right=3, top=3, bottom=3}
    }
  }

  --  Functions
  local function GetHexColor(color)
    if color.r then
      return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
    else
      local r,g,b,a = unpack(color)
      return ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
    end
  end

  local function GetTarget(unit)
    if UnitIsUnit(unit, "player") then
      return ("|cffff0000%s|r"):format("<YOU>")
    elseif UnitIsPlayer(unit, "player") then
      local _, class = UnitClass(unit)
      return ("|cff%s%s|r"):format(classColorHex[class], UnitName(unit))
    elseif UnitReaction(unit, "player") then
      return ("|cff%s%s|r"):format(factionColorHex[UnitReaction(unit, "player")], UnitName(unit))
    else
      return ("|cffffffff%s|r"):format(UnitName(unit))
    end
  end

  local function OnTooltipSetUnit(self)
    local unitName, unit = self:GetUnit()
    if not unit then return end
    --  Color tooltip textleft
    for i = 2, GameTooltip:NumLines() do
      local line = _G["GameTooltipTextLeft"..i]
      if line then
        line:SetTextColor(unpack(cfg.textColor))
      end
    end
    --  Position raid icon
    local raidIconIndex = GetRaidTargetIndex(unit)
    if raidIconIndex then
      GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex].."14|t", unitName))
    end

    if not UnitIsPlayer(unit) then
      --  Unit is not a player
      --  Color textleft1 and statusbar by faction color
      local reaction = UnitReaction(unit, "player")
      if reaction then
        local color = FACTION_BAR_COLORS[reaction]
        if color then
          cfg.barColor = color
          GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
          _G["GameTooltipTextLeft1"]:SetTextColor(color.r,color.g,color.b)
        end
      end
      --  Color textleft2 by classification color
      local unitClassification = UnitClassification(unit)
      local levelLine

      if string.find(_G["GameTooltipTextLeft2"]:GetText() or "empty", "%a%s%d") then
        levelLine = _G["GameTooltipTextLeft2"]
      elseif string.find(_G["GameTooltipTextLeft3"]:GetText() or "empty", "%a%s%d") then
        --  Seems like the npc has a description, use the guild color for this
        _G["GameTooltipTextLeft2"]:SetTextColor(unpack(cfg.guildColor))
        levelLine = _G["GameTooltipTextLeft3"]
      end

      if levelLine then
        local l = UnitLevel(unit)
        local color = GetCreatureDifficultyColor((l > 0) and l or 999)
        levelLine:SetTextColor(color.r,color.g,color.b)
      end

      if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
        self:AppendText(" |cffff0000{B}|r")
      elseif unitClassification == "rare" then
        self:AppendText(" |cffff9900{R}|r")
      elseif unitClassification == "rareelite" then
        self:AppendText(" |cffff0000{R+}|r")
      elseif unitClassification == "elite" then
        self:AppendText(" |cffff6666{E}|r")
      end
    else
      --  Unit is any player
      local _, unitClass = UnitClass(unit)
      --  Color textleft1 and statusbar by class color
      local color = RAID_CLASS_COLORS[unitClass]
      cfg.barColor = color
      GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
      _G["GameTooltipTextLeft1"]:SetTextColor(color.r,color.g,color.b)
      --  Color textleft2 by guildcolor
      local guildName, guildRank = GetGuildInfo(unit)
      if guildName then
        _G["GameTooltipTextLeft2"]:SetText("<"..guildName.."> ["..guildRank.."]")
        _G["GameTooltipTextLeft2"]:SetTextColor(unpack(cfg.guildColor))
      end

      local levelLine = guildName and _G["GameTooltipTextLeft3"] or _G["GameTooltipTextLeft2"]
      local l = UnitLevel(unit)
      local color = GetCreatureDifficultyColor((l > 0) and l or 999)

      levelLine:SetTextColor(color.r,color.g,color.b)
      --  Afk?
      if UnitIsAFK(unit) then
        self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
      end
    end
    --  Dead?
    if UnitIsDeadOrGhost(unit) then
      _G["GameTooltipTextLeft1"]:SetTextColor(unpack(cfg.deadColor))
    end
    --  Target line
    if (UnitExists(unit.."target")) then
      GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"),GetTarget(unit.."target") or "Unknown")
    end
  end

  local function SetBackdropStyle(self,style)
    --  Do nothing on embedded tooltips
    if self.IsEmbedded then return end
    if self.TopOverlay then self.TopOverlay:Hide() end
    if self.BottomOverlay then self.BottomOverlay:Hide() end
    --self:SetBackdrop(cfg.backdrop)
    --self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
    local _, itemLink = self:GetItem()
    if itemLink then
      local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
      local _, _, itemRarity = GetItemInfo(itemLink)
      local r,g,b = 1,1,1
      if itemRarity then r,g,b = GetItemQualityColor(itemRarity) end
      --  Use azerite coloring or item rarity
      if azerite and cfg.backdrop.azeriteBorderColor then
        self:SetBackdropBorderColor(unpack(cfg.backdrop.azeriteBorderColor))
      else
        self:SetBackdropBorderColor(r,g,b,cfg.backdrop.itemBorderColorAlpha)
      end
    else
      --  No item, use default border
      --self:SetBackdropBorderColor(unpack(cfg.backdrop.borderColor))
    end
  end

  local function SetStatusBarColor(self,r,g,b)
    if not cfg.barColor then return end
    if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
    self:SetStatusBarColor(cfg.barColor.r,cfg.barColor.g,cfg.barColor.b)
  end

  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    tooltip:SetOwner(parent, "ANCHOR_NONE")
    tooltip:ClearAllPoints()
    tooltip:SetPoint(unpack(cfg.pos))
  end)

  --  Init
  --  Hex class colors
  for class, color in next, RAID_CLASS_COLORS do
    classColorHex[class] = GetHexColor(color)
  end

  --  Hex reaction colors
  --for idx, color in next, FACTION_BAR_COLORS do
  for i = 1, #FACTION_BAR_COLORS do
    factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
  end

  cfg.targetColorHex = GetHexColor(cfg.targetColor)
  cfg.afkColorHex = GetHexColor(cfg.afkColor)

  GameTooltipHeaderText:SetFont(cfg.fontFamily, 14, "NONE")
  GameTooltipHeaderText:SetShadowOffset(1,-2)
  GameTooltipHeaderText:SetShadowColor(0,0,0,0.75)
  GameTooltipText:SetFont(cfg.fontFamily, 12, "NONE")
  GameTooltipText:SetShadowOffset(1,-2)
  GameTooltipText:SetShadowColor(0,0,0,0.75)
  Tooltip_Small:SetFont(cfg.fontFamily, 11, "NONE")
  Tooltip_Small:SetShadowOffset(1,-2)
  Tooltip_Small:SetShadowColor(0,0,0,0.75)

  --  Gametooltip statusbar
  GameTooltipStatusBar:ClearAllPoints()
  GameTooltipStatusBar:SetPoint("LEFT",5,0)
  GameTooltipStatusBar:SetPoint("RIGHT",-5,0)
  GameTooltipStatusBar:SetPoint("TOP",0,-2.5)
  GameTooltipStatusBar:SetHeight(4)
  --  Gametooltip statusbar bg
  GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
  GameTooltipStatusBar.bg:SetAllPoints()
  GameTooltipStatusBar.bg:SetColorTexture(1,1,1)
  GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.5)

  hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", SetStatusBarColor)
  GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

  --  Loop over tooltips
  local tooltips = {
    Gametooltip,
    ShoppingTooltip1,
    ShoppingTooltip2,
    ItemRefTooltip,
    ItemRefShoppingTooltip1,
    ItemRefShoppingTooltip2,
    WorldMapTooltip,
    WorldMapCompareTooltip1,
    WorldMapCompareTooltip2,
    SmallTextTooltip
  }
  for i, tooltip in next, tooltips do
    tooltip:SetScale(cfg.scale)
    if tooltip:HasScript("OnTooltipCleared") then
      tooltip:HookScript("OnTooltipCleared", SetBackdropStyle)
    end
  end

  --  Loop over menues
  local menues = {
    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
  }
  for i, menu in next, menues do
    menu:SetScale(cfg.scale)
  end

  --  Spellid line

  --  Func TooltipAddSpellID
  local function TooltipAddSpellID(self,spellid)
    if not spellid then return end
    self:AddDoubleLine("|cff0099ffID|r",spellid)
    self:Show()
  end

  --  Hooksecurefunc GameTooltip SetUnitBuff
  hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
    TooltipAddSpellID(self,select(10,UnitBuff(...)))
  end)

  --  Hooksecurefunc GameTooltip SetUnitDebuff
  hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
    TooltipAddSpellID(self,select(10,UnitDebuff(...)))
  end)

  --  Hooksecurefunc GameTooltip SetUnitAura
  hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
    TooltipAddSpellID(self,select(10,UnitAura(...)))
  end)

  --  Hooksecurefunc SetItemRef
  hooksecurefunc("SetItemRef", function(link)
    local type, value = link:match("(%a+):(.+)")
    if type == "spell" then
      TooltipAddSpellID(ItemRefTooltip,value:match("([^:]+)"))
    end
  end)

  --  HookScript GameTooltip OnTooltipSetSpell
  GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    TooltipAddSpellID(self,select(2,self:GetSpell()))
  end)
end)