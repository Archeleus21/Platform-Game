---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function love.load()
  --physics--
  --newWorld(gravityX, gravityY, sleep)
  gameWorld = love.physics.newWorld(nil, 400, false)
  --checks if grounded, built functions inside () below --
  gameWorld:setCallbacks(BeginContact, EndContact, preSolve, postSolve)

  --files / classes--
  require('sprites')
  require('coin')
  require('player')

  --platforms table--
  platforms = {}

  --create a platform to test with preset location and size--
  SpawnPlatform(50, 400, 300, 30)

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
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
function love.draw()
  -- body...
  --lets draw the player--
  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player_idle:getWidth()/2, (sprites.player_idle:getHeight()/2) + 8)

  --lets cycle through the platforms table and draw each platform--
  for i,p in ipairs(platforms) do
    love.graphics.rectangle('fill', p.body:getX(), p.body:getY(), p.width, p.height)
  end

  love.graphics.draw(tempSprite.coin_sprite, 100, 200, nil, nil, nil, tempSprite.coin_sprite:getWidth()/2, nil)
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
