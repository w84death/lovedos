function prepareGame()
end

function drawGame()
  if game_mode == game_single then
    love.graphics.draw(gif_bg_dark,0,0)
    love.graphics.print(
      "THIS IS THE SINGLE PLAYER GAME...",
      12,12)
  end
  if game_mode == game_multi then
    love.graphics.draw(gif_bg_light,0,0)
    
    love.graphics.print(
      "THIS IS THE MULTI PLAYER GAME...",
      12,12)
  end
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
