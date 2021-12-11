local Coords_UpdateInterval = 0.2
timeSinceLastUpdate = 0

--  setup event frame
local Coords_eventFrame = CreateFrame("Frame")
Coords_eventFrame:RegisterEvent("VARIABLES_LOADED")
Coords_eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Coords_eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
Coords_eventFrame:RegisterEvent("ZONE_CHANGED")
Coords_eventFrame:SetScript("OnEvent", function(self, event, ...)
  self[event] (self, event, ...)
end)

--  parse events handlers
function Coords_eventFrame:VARIABLES_LOADED()
  Coords_eventFrame:SetScript("OnUpdate", function(self, elapsed)
    Coords_OnUpdate(self, elapsed)
  end)
end

function Coords_eventFrame:ZONE_CHANGED_NEW_AREA()
  Coords_UpdateCoords()
end

function Coords_eventFrame:ZONE_CHANGED_INDOORS()
  Coords_UpdateCoords()
end

function Coords_eventFrame:ZONE_CHANGED()
  Coords_UpdateCoords()
end

--  on update
function Coords_OnUpdate(self, elapsed)
  timeSinceLastUpdate = timeSinceLastUpdate + elapsed
  if (timeSinceLastUpdate > Coords_UpdateInterval) then
    -- update the update time
    timeSinceLastUpdate = 0
    Coords_UpdateCoords()
  end
end

--  world map coordinates
function Coords_UpdateCoords()
  if (WorldMapFrame:IsVisible()) then
    if (IsInInstance()) then
      playerWMText = ""
    else
      --  calculate player position
      local _P = GetUnitName("player")
      local mapID = C_Map.GetBestMapForUnit("player")
      
      if mapID then
        local mapPos = C_Map.GetPlayerMapPosition(mapID, "player")
        if mapPos then
          playerX, playerY = mapPos:GetXY()
        end
      else
        playerX = 0
        playerY = 0
      end

      if playerX == 0 or playerY == 0 or playerX == nil or playerY == nil then
        playerWMText = ""
      else
        playerWMText = " | " .. _P .. ": (" .. format("%.1f, %.1f", playerX * 100, playerY * 100) .. ")"
      end
    end

    --  calculate cursor position
    if (IsInInstance()) then
      cursorWMText = ""
    else
      local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()

      if (cursorX > 0 and cursorY > 0 and cursorX < 1 and cursorY < 1) then
        cursorX = (cursorX * 100)
        cursorY = (cursorY * 100)
        cursorWMText = " | Cursor: (" .. format("%.1f, %.1f", cursorX, cursorY) .. ")"
      else
        cursorWMText = ""
      end
    end

    --  add text output to world map top border
    WorldMapFrame.BorderFrame.TitleText:SetText(MAP_AND_QUEST_LOG .. playerWMText .. cursorWMText)
  end
end