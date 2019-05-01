tempSprite = {}
tempSprite.coin_sprite = sprites.bronze_coin1
--used to cycle through sprites for coin rotation--
tempA = 1
--every 1/10th of a second or so change sprites--
maxTime = 0.15
cTime = maxTime

coins = {}

function CoinUpdate(dt)
  ---------------------------------------------------------------------
  --used for coin rotation animation--
  cTime = cTime - dt

  if cTime <= 0 then
    tempA = tempA + 1
    cTime = maxTime
    if tempA == 1 then
      tempSprite.coin_sprite =  sprites.bronze_coin1
    elseif tempA == 2 then
      tempSprite.coin_sprite = sprites.bronze_coin2
    elseif tempA == 3 then
      tempSprite.coin_sprite = sprites.bronze_coin3
    elseif tempA == 4 then
      tempSprite.coin_sprite = sprites.bronze_coin4
    elseif tempA == 5 then
      tempSprite.coin_sprite = sprites.bronze_coin5
    elseif tempA == 6 then
      tempSprite.coin_sprite = sprites.bronze_coin6
      tempA = 1
    end
  end
  -----------------------------------------------------------------------
  --checking for player collision with coins--
  for  i,c in ipairs(coins) do
    if DistanceBetween(c.x, c.y, player.body:getX(), player.body:getY()) < 50 then
      c.collected = true
    end
  end

  --if collected then destroys/removes coin from table--
  for i = #coins, 1, -1 do
    local c = coins[i]
    if c.collected == true then
      table.remove(coins[i])
    end
  end
end

--used to spawn coins in game--
function SpawnCoin(x, y)
  local coin = {}
  coin.x = x
  coin.y = y
  coin.collected = false

  table.insert(coins, coin)
end
