SLASH_EA1 = "/rg"

--  Show grid lines for perfect aligning of your UI

local rgrid

SlashCmdList["EA"] = function()

    if rgrid then
        rgrid:Hide()
        rgrid = nil
    else
        rgrid = CreateFrame("Frame", nil, UIParent)
        rgrid:SetAllPoints(UIParent)

        local w = GetScreenWidth() / 64
        local h = GetScreenHeight() / 36

        for i = 0, 64 do
            local t = rgrid:CreateTexture(nil, "BACKGROUND")
            if i == 32 then
                t:SetColorTexture(1, 1, 0, 0.5)
            else
                t:SetColorTexture(1, 1, 1, 0.15)
            end
            t:SetPoint("TOPLEFT", rgrid, "TOPLEFT", i * w - 1, 0)
            t:SetPoint("BOTTOMRIGHT", rgrid, "BOTTOMLEFT", i * w + 1, 0)
        end

        for i = 0, 36 do
            local t = rgrid:CreateTexture(nil, "BACKGROUND")
            if i == 18 then
                t:SetColorTexture(1, 1, 0, 0.5)
            else
                t:SetColorTexture(1, 1, 1, 0.15)
            end
            t:SetPoint("TOPLEFT", rgrid, "TOPLEFT", 0, -i * h + 1)
            t:SetPoint("BOTTOMRIGHT", rgrid, "TOPRIGHT", 0, -i * h  -1)
        end
    end
end
