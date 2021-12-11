local rui = CreateFrame("Frame")
rui:RegisterEvent("PLAYER_LOGIN")
rui:SetScript("OnEvent", function(self, event)

  if not ruiDB.A_STOPWATCH == true then return end

  Stopwatch_Toggle()
  StopwatchFrame:SetFrameStrata(BACKGROUND)
end)