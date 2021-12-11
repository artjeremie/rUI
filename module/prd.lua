--  Personal resource display color by health missing
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
  if frame.optionTable.colorNameBySelection and not frame:IsForbidden() then
    local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))

    if C_NamePlate.GetNamePlateForUnit(frame.unit) == C_NamePlate.GetNamePlateForUnit("player") then
      if healthPercentage == 100 then
        frame.healthBar:SetStatusBarColor(0, 1, 0)
      elseif
        healthPercentage < 100 and healthPercentage >= 75 then
        frame.healthBar:SetStatusBarColor(0.6, 0.8, 0.19)
      elseif
        healthPercentage < 75 and healthPercentage >= 50 then
        frame.healthBar:SetStatusBarColor(1, 1, 0)
      elseif
        healthPercentage < 50 and healthPercentage >= 25 then
        frame.healthBar:SetStatusBarColor(1, 0.64, 0)
      elseif
        healthPercentage < 25 then
        frame.healthBar:SetStatusBarColor(1, 0, 0)
      end
    end
  end
end)