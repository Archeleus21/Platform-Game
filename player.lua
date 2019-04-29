player = {}
--rigid body--
--newbody(world you created, x, y, dynamic or static)--
player.body = love.physics.newBody(gameWorld, 100, 100, 'dynamic')
--collision box--
player.shape = love.physics.newRectangleShape(66, 92)
--puts shape in place--
--newFixture(body, shape, density)--
player.fixture = love.physics.newFixture(player.body, player.shape)
--speed--
player.speed = 200
--checks if player is on ground--
player.grounded = false
--which way player is looking--
player.direction = 1
--current sprite assigned to player--
player.sprite = sprites.player_idle
--constrain physics rotations to prevent player from rolling off edges--
player.body:setFixedRotation(true)

function PlayerUpdate(dt)
  --player controls--
  if love.keyboard.isDown('a') then
    --changes players body x value--
    player.body:setX(player.body:getX() - player.speed * dt)
    player.direction = -1
  end

  if love.keyboard.isDown('d') then
    --changes players body x value--
    player.body:setX(player.body:getX() + player.speed * dt)
    player.direction = 1
  end

  --checks if player is grounded to show proper sprite--
  if player.grounded == true then
    player.sprite = sprites.player_idle
  else
    player.sprite = sprites.player_jump
  end

end

--jump--
function love.keypressed(key, scancode, isrepeat)
  -- body...
  if key == 'space' and player.grounded == true then
    --impulse applied to player's body(x,y)--
    player.body:applyLinearImpulse(0, -2000)
  end
end
