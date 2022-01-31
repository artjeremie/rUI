local rui = CreateFrame("Frame")
rui:RegisterEvent("ADDON_LOADED")
rui:SetScript("OnEvent", function(self, event)

    --  Main actionbar artwork
    if ruiDB.A_ARTWORK == true then
        MainMenuBarArtFrame.LeftEndCap:Hide()
        MainMenuBarArtFrame.RightEndCap:Hide()
        MainMenuBarArtFrame.PageNumber:Hide()
        MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)
        MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
    end

    --  Auto add spell in actionbar
    if ruiDB.A_AUTOADDSPELL == true then
        IconIntroTracker.RegisterEvent = function() end
        IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
    end

    --  Extra bar artwork
    if ruiDB.A_EXTRABAR == true then
        ExtraActionButton1.style:SetAlpha(0)
        ZoneAbilityFrame.Style:SetAlpha(0)
    end
end)
