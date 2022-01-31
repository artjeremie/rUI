local rautosellrepair = CreateFrame("Frame")
rautosellrepair:RegisterEvent("MERCHANT_SHOW")

rautosellrepair:SetScript("OnEvent", function()

  --  auto vendor grays
  totalPrice = 0
  for bags = 0, 4 do
    for slots = 1, GetContainerNumSlots(bags) do
      CurrentItemLink = GetContainerItemLink(bags, slots)
      if CurrentItemLink then
        _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink)
        _, itemCount = GetContainerItemInfo(bags, slots)

        if itemRarity == 0 and itemSellPrice ~= 0 then
          totalPrice = totalPrice + (itemSellPrice * itemCount)
          UseContainerItem(bags, slots)
          PickupMerchantItem()
        end
      end
    end
  end
  if totalPrice ~= 0 then
    print('Sold your gray items for ' .. GetCoinTextureString(totalPrice))
  end
  
  --  auto repairs
  if(CanMerchantRepair()) then
    local cost = GetRepairAllCost()
    if cost > 0 then
      local money = GetMoney()
      if money > cost then
        RepairAllItems()
        print('Repairing all items for ' .. GetCoinTextureString(cost))
      else
        print("Not enough gold to cover the repair cost.")
      end
    end
  end
end)