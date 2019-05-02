---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function love.load()
  --change the default from  880x600 to whatever i want--
  love.window.setMode(900, 700)
  --physics--
  --newWorld(gravityX, gravityY, sleep)
  gameWorld = love.physics.newWorld(nil, 400, false)
  --checks if grounded, built functions inside () below --
  gameWorld:setCallbacks(BeginContact, EndContact, preSolve, postSolve)

  --files / classes--
  require('sprites')  --all sprites used for game--
  require('coin')  --coin class--
  require('player')  --player class--
  require('show')  --used to serialize saveData--

  --used to implement tile maps--
  sti = require('Simple-Tilemap-Implementation/sti')
  --used for camera implementation--
  cameraFile = require('HUMP Library/hump-master/camera')  --beecomes a "function"--
  cam = cameraFile()
  --platforms table--
  platforms = {}
  --saved data--
  saveData = {}
  saveData.bestTime = 999  --default value--
  --checks if file as already been created--
  if love.filesystem.getInfo("saveData.lua") then
    --stores the data in the file if it already exists--
    local data = love.filesystem.load("saveData.lua") --stores it as a function--
    data()
  end

  --store the gameMap--
  gameMap = sti("Sprites/Maps/GameMap.lua")
--create a platform using the parameteres from the tilemap creator--
  for i, obj in pairs(gameMap.layers["Platforms"].objects) do
    SpawnPlatform(obj.x, obj.y, obj.width, obj.height)
  end

  --spawn coins using the parameters and object placement from the tile map creator--
  for i, obj in pairs(gameMap.layers["Coins"].objects) do
    SpawnCoin(obj.x, obj.y)
  end

  --game state--
  gameState = 1
  --font--
  gameFont = love.graphics.newFont(30)
  --game timer--
  timer = 0

end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function love.update(dt)
  -- body...
  --update the physics--
  gameWorld:update(dt)

  --update player--
  PlayerUpdate(dt)
  --coin animation--
  CoinUpdate(dt)
  --update map--
  gameMap:update(dt)
  --update camera--
  cam:lookAt(player.body:getX(), player.body:getY()) --locks cam to center of screen--

  --time counter--
  if gameState == 2 then
    timer = timer + dt
  end

  --checks if all coins are collected--
  if #coins == 0 and gameState == 2 then
    gameState = 1
    --resets player position--
    player.body:setPosition(100, 400)

    --respawns coins at end of game/all coins are collected--
    if #coins == 0 then
      for i, obj in pairs(gameMap.layers["Coins"].objects) do
        SpawnCoin(obj.x, obj.y)
      end
    end

    --saving data to file--
    if timer < saveData.bestTime then
      saveData.bestTime = math.floor(time)
      love.filesystem.write("saveData.lua", table.show(saveData, "saveData"))
    end
  end
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function love.draw()
  -- body...
  --draws background--
  love.graphics.draw(sprites.background)
  --testing collisions--
  if cCollected == true then
    love.graphics.print("collected", 50, 50)
  end
  if cDestroyed == true then
    love.graphics.print("Destroyed", 50, 70)
  end
  --start camera--
  cam:attach()
  --draw map--
  gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
  --lets draw the player--
  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player_idle:getWidth()/2, (sprites.player_idle:getHeight()/2) + 8)
  --draws coins--
  for i,c in ipairs(coins) do
    love.graphics.draw(tempSprite.coin_sprite, c.x, c.y, nil, nil, nil, tempSprite.coin_sprite:getWidth()/2, nil)
  end

  --stop camera--
  cam:detach()
  --user interface--
  if gameState == 1 then
    love.graphics.setFont(gameFont)
    love.graphics.printf("Press any key to Start!", 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Best Time: " .. saveData.bestTime, 0, 150, love.graphics.getWidth(), "center")
  end
  --shows timer--
  love.graphics.print("Time: " .. math.floor(timer), 10, 660)
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--function to create platforms, (posX, posY, width, height)--
function SpawnPlatform(x, y, width, height)
  --table--
  local platform = {}
  --rigid body--
  platform.body = love.physics.newBody(gameWorld, x, y, 'static')
  --collision shape--
  platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
  --attack collision shape to body--
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)
  --stores width and height--
  platform.width = width
  platform.height = height

  --inserts each platform into the platforms table--
  table.insert(platforms, platform)
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function BeginContact(a, b, coll)
  player.grounded = true
end

function EndContact(a, b, coll)
  player.grounded = false
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function DistanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
