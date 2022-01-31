local rui = CreateFrame("Frame")
rui:RegisterEvent("ADDON_LOADED")
rui:SetScript("OnEvent", function(self, event)

  if not ruiDB.A_TALKINGHEAD == true then return end

  local function HookTalkingHead()
    hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
      TalkingHeadFrame:Hide()
    end)
  end

  if TalkingHeadFrame then
    HookTalkingHead()
  else
    hooksecurefunc('TalkingHead_LoadUI', HookTalkingHead)
  end
end)