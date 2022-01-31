local rui = CreateFrame("Frame")
rui:RegisterEvent("ADDON_LOADED")
rui:SetScript("OnEvent", function(self, event)

  --  Make prd resource large
  if ruiDB.A_PRDRESOURCE == true then
    ClassNameplateBarRogueDruidFrame:SetScale(1.50)
    ClassNameplateBarMageFrame:SetScale(1.50)
    ClassNameplateBarPaladinFrame:SetScale(1.50)
  end
end)