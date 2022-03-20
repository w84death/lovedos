function prepareGame()
end

function drawGame()
  love.graphics.print(
    "THIS IS THE GAME...",
    12,12)
end

function tickGame(dt)
end


function drawGameOver(win)
  if win then
    love.graphics.print(
      "YOU WIN!",
      12,12)
  else
    love.graphics.print(
      "YOU LOSE :(",
      12,12)
  end
end