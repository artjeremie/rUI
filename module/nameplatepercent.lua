-- Name on nameplate resize
local function ScaleNameplateNames(...)
  for i, frame in ipairs(C_NamePlate.GetNamePlates()) do
    local names = frame.UnitFrame.name
    names:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
  end
end
NamePlateDriverFrame:HookScript("OnEvent", ScaleNameplateNames)

--  Health percent text
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
  if frame.optionTable.colorNameBySelection and not frame:IsForbidden() then
    local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))

    if not frame.health then
      frame.health = CreateFrame("Frame", nil, frame)
      frame.health:SetSize(170, 16)
      frame.health.text = frame.health.text or frame.health:CreateFontString(nil, "OVERLAY")
      frame.health.text:SetAllPoints(true)
      frame.health:SetFrameStrata("HIGH")
      frame.health:SetPoint("CENTER", frame.healthBar)
      frame.health.text:SetVertexColor(1, 1, 1)
      frame.health.text:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
    end

    frame.health.text:Show()
    frame.health.text:SetText(healthPercentage .. "%")
  end
end)