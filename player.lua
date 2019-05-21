require('sprites')
player = {}
--rigid body--
--newbody(world you created, x, y, dynamic or static)--
player.body = love.physics.newBody(gameWorld, 100, 400, 'dynamic')
--collision box--
player.shape = love.physics.newRectangleShape(75, 92)
--puts shape in place--
--newFixture(body, shape, density)--
player.fixture = love.physics.newFixture(player.body, player.shape)
--speed--
player.speed = 300
--used to check if player is on ground--
player.grounded = false
--which way player is looking--
player.direction = 1
--current sprite assigned to player--
player.sprite = sprites.player_idle
--constrain physics rotations to prevent player from rolling off edges--
player.body:setFixedRotation(true)

--walking animation
walkingSprites = {}
walkingSprites[1] = sprites.walk_right1
walkingSprites[2] = sprites.walk_right2
--animation speed
animSpeed = 0
animSprite = 1

isWalking = false


function PlayerUpdate(dt)
  --cant move unless game started--
  if gameState == 2 then
    iswalking = false
    player.sprite = sprites.player_idle
    --player controls--
    if love.keyboard.isDown('a') then
      --changes players body x value--
      player.body:setX(player.body:getX() - player.speed * dt)
      player.direction = -1

      --is player walking--
      isWalking = true
      --counter for animation--
      animSpeed = animSpeed + dt
      --sets sprite to first sprite for animation--
      player.sprite = walkingSprites[animSprite]

      --cycles through 2 sprites--
      if animSpeed > 0.2 then
        animSprite = animSprite + 1
        animSpeed = 0
      end

      --resets sprite back to first to create loopint sprites--
      if animSprite > 2 then
        animSprite = 1
      end
    end

    if love.keyboard.isDown('d') then
      --changes players body x value--
      player.body:setX(player.body:getX() + player.speed * dt)
      player.direction = 1

      --is player walking--
      isWalking = true
      --counter for animation--
      animSpeed = animSpeed + dt
      --sets sprite to first sprite for animation--
      player.sprite = walkingSprites[animSprite]

      --cycles through 2 sprites--
      if animSpeed > 0.2 then
        animSprite = animSprite + 1
        animSpeed = 0
      end

      --resets sprite back to first to create loopint sprites--
      if animSprite > 2 then
        animSprite = 1
      end
    end
    --checks which sprite to show if grounded--
    PlayerGrounded()
  end
end

--jump--
function love.keypressed(key, scancode, isrepeat)
  -- body...
  --cant jump  unless game is started--
  if gameState == 2 then
    if key == 'space' and player.grounded == true then
      --impulse applied to player's body(x,y)--
      player.body:applyLinearImpulse(0, -3600)
      --plays sound for jump
      blipSound:play()
    end
  end

  --starts game when a key is pressed--
  if gameState == 1 then
    gameState = 2
    timer = 0
  end
end

--checks if player is grounded to show proper sprite--
function PlayerGrounded()
  --checks if player is grounded to show proper sprite--
  if isWalking == false or player.grounded == false then
    player.sprite = sprites.player_jump
  end
end
