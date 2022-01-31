local rui = CreateFrame("Frame")
rui:RegisterEvent("PLAYER_ENTERING_WORLD")
rui:SetScript("OnEvent", function(self, event)

    if not ruiDB.A_PLATESHORT == true then return end

    local width = ruiDB.PLATESHORT.W
    local height = ruiDB.PLATESHORT.H

    C_NamePlate.SetNamePlateFriendlySize(width, height)
end)
