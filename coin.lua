tempSprite = {}
tempSprite.coin_sprite = sprites.bronze_coin1

coins = {}
tempA = 1
tempB = 0

maxTime = 0.15
cTime = maxTime



function CoinUpdate(dt)
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
end

function SpawnCoin(x, y)
  local coin = {}

  coin.x = x
  coin.y = y

  table.insert(coins, coin)
end
