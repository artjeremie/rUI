local rui = CreateFrame("Frame")
rui:RegisterEvent("ADDON_LOADED")
rui:SetScript("OnEvent", function(self, event)

  if not ruiDB.A_ALERTS == true then return end

  --  UI error text
  UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

  --  Loot rolls
  AlertFrame:UnregisterEvent("LOOT_ITEM_ROLL_WON")
  AlertFrame:UnregisterEvent("SHOW_LOOT_TOAST")

  --  BossBanner
  BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
  BossBanner:UnregisterEvent("BOSS_KILL")
end)