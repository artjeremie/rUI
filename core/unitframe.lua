local rui = CreateFrame("Frame")
rui:RegisterEvent("ADDON_LOADED")
rui:SetScript("OnEvent", function(self, event)

  if not ruiDB.A_UNITFRAMES == true then return end

  --  Class color in unitframe healthbar
  local function colorBar(statusbar, unit)
    local _, class, c
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
      _, class = UnitClass(unit)
      c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
      statusbar:SetStatusBarColor(c.r, c.g, c.b)
    end
  end
  hooksecurefunc("UnitFrameHealthBar_Update", colorBar)
  hooksecurefunc("HealthBar_OnValueChanged", function(self)
    colorBar(self, self.unit)
  end)

  --  Set the color player and enemy names based on class
  hooksecurefunc("UnitFrame_Update", function(self)
    if UnitClass(self.unit) then
      local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(self.unit))]
      self.name:SetTextColor(c.r, c.g, c.b, 1)
    end
  end)

  --  Set unitframes name background to transparent
  local UnitClass = UnitClass
  hooksecurefunc("TargetFrame_CheckFaction", function(self)
    local _, class = UnitClass(self.unit)
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5)
  end)

  --  Disble unitframe status text
  PlayerHitIndicator:SetText(nil)
  PlayerHitIndicator.SetText = function() end
  PetHitIndicator:SetText(nil)
  PetHitIndicator.SetText = function() end

  --  Disable unitframe glow while in resting area
  hooksecurefunc("PlayerFrame_UpdateStatus", function()
    if IsResting("player") then
      PlayerStatusTexture:Hide()
      PlayerRestGlow:Hide()
      PlayerStatusGlow:Hide()
    end
  end)
end)