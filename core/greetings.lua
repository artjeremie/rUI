local rui = CreateFrame("Frame")
rui:RegisterEvent("PLAYER_LOGIN")
rui:SetScript("OnEvent", function(self, event)

    --  Greetings
    if not ruiDB.A_GREETINGS == true then return end

    print("Welcome to |cff00ff00r|r|cff009cffUI|r type |CFFFAC025/rh|r for list of commands.")
end)
