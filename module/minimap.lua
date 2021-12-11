--  Hide some minimap textures
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Scrollwheel to zoom in and zoom out
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, arg1)
  if arg1 > 0 then
    Minimap_ZoomIn()
  else
    Minimap_ZoomOut()
  end
end)