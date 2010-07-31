ball = display.newImage("ball.png")
enemy = display.newImage("paddle.png")
player = display.newImage("paddle.png")

player.lives = 0
player.speed = 10
player.moving = false

enemy.speed = 10

player:scale(3.0, 3.0)
enemy:scale(3.0, 3.0)

ballHalf = ball.height / 2
paddleHalf = player.height / 2

local reset = function()
  ball.x = display.contentWidth / 2
  ball.y = display.contentHeight / 2

  player.x = player.width * 2
  player.y = display.contentHeight / 2

  enemy.x = display.contentWidth - enemy.width * 2
  enemy.y = display.contentHeight / 2

  ball.dx = 9
  ball.dy = 9
end


local boundY = function(paddle)
  if paddle.y - paddleHalf < 0 then
    paddle.y = paddleHalf
  end

  if paddle.y + paddleHalf > display.contentHeight then
    paddle.y = display.contentHeight - paddleHalf
  end
end

reset()

Runtime:addEventListener("touch", function(event)
  if player.y < event.y then
    player.y = player.y + player.speed
  else
    player.y = player.y - player.speed
  end

  boundY(player)
end)

local didCollide = function(a, b)
  return (a.x + a.width >= b.x) and
         (a.x + a.width <= b.x + b.width) and
         (a.y + a.height >= b.y) and
         (a.y + a.height <= b.y + b.height)
end

Runtime:addEventListener("enterFrame", function(event)
  if ball.y + ballHalf > display.contentHeight or ball.y - ballHalf < 0 then
    ball.dy = -ball.dy
  end

  if ball.x - ballHalf < 0 or ball.x + ballHalf > display.contentWidth then
    player.lives = player.lives + 1
    reset()
  end

  ball:translate(ball.dx, ball.dy)

  -- enemy ai
  if ball.dx > 0 then
    if enemy.y > ball.y then
      enemy:translate(0, -enemy.speed)
    else
      enemy:translate(0, enemy.speed)
    end
    boundY(enemy)
  end

  if didCollide(player, ball) or didCollide(enemy, ball) then
    ball.dx = -ball.dx
  end
end)