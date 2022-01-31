--  Reload
SLASH_ruiReload1 = "/rl"
SlashCmdList["ruiReload"] = ReloadUI

--  Help commands
SLASH_RUI_CMD1 = "/rh"
SlashCmdList["RUI_CMD"] = function()
    print("|cff00ff00r|r|cff009cffUI|r " .. "|cfffbff00" .. "Command List:")
    print("|cfffbff00" .. "/rui " .. "|cff00fffb" .. "Options")
    print("|cfffbff00" .. "/rg " .. "|cff00fffb" .. "Show Grids")
    print("|cfffbff00" .. "/rl " .. "|cff00fffb" .. "Reload")
    print("|cfffbff00" .. "/rh " .. "|cff00fffb" .. "Show Command List Again")
end

--  Hide loss of control background
LossOfControlFrame.blackBg:SetAlpha(0)
LossOfControlFrame.RedLineTop:SetAlpha(0)
LossOfControlFrame.RedLineBottom:SetAlpha(0)
