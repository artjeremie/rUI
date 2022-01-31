local rui = CreateFrame("Frame")
rui:RegisterEvent("PLAYER_LOGIN")
rui:SetScript("OnEvent", function(self, event)
  -- Disable glow effect, blizzard default, 1 
  SetCVar("ffxglow", 0)
  --  Disable blur effect while invis, blizzard default, 1
  SetCVar("ffxNether", 0)
  --  Disable desaturation effect while dead, blizzard default, 1
  SetCVar("ffxDeath", 0)
  --  Disable map fade, blizzard default, 1
  SetCVar("mapFade", 0)
  --  Set max quality of screenshot, blizzard default, 3
  SetCVar("screenshotQuality", 10)
  --  Show friendly player name only on click, blizzard default, 1
  SetCVar("UnitNameFriendlyPlayerName", 0)
  --  Show enemy player name only on click, blizzard default, 1
  SetCVar("UnitNameEnemyPlayerName", 0)
  --  Always show personal resource display, blizzard default, 0
  SetCVar("NameplatePersonalShowAlways", 0)
  --  Move personal resource display Top Inset, blizzard default, 0.5
  --  Set to 0.74 for static prd, and set to 0.75 to avoid overlapping by castbar
  SetCVar("nameplateSelfTopInset", 0.5)
  --  Move personal resource display Bottom Inset, blizzard default, 0.2
  --  Set to 0.44 for static prd on top
  SetCVar("nameplateSelfBottomInset", 0.44)
  --  Prd hidden when out of combat, blizzard default, 3.0
  SetCVar("NameplatePersonalHideDelaySeconds", 0.1)
  --  Prd alpha when out of combat, blizzard default, 0.45
  SetCVar("NameplatePersonalHideDelayAlpha", 0.1)
  --  Show lua errors, blizzard default, 0
  SetCVar("scriptErrors", 1)
end)