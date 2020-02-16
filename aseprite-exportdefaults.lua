--Based on https://gist.github.com/rapsaGnauJ/5c4c43f060d633369b9447ae21cc4491

local sprite = app.activeSprite

function getPath(str, sep)
  sep = sep or "/"
  return str:match("(.*" .. sep .. ")")
end

function getFileName(str, sep)
  str = str:match("^.+" .. sep .. "(.+)$")
  return str:match("(.+)%..+")
end

function exportSaveClose(path, spriteName)
  --export to a temporary new tab with default settings
  app.command.ExportSpriteSheet({ui = false, dataFilename = spriteName})
  --save as png
  local spriteToSave = app.activeSprite
  spriteToSave:saveAs(path .. spriteName .. ".png")
  --close temporary tab
  spriteToSave:close()
end

if (sprite == nil) then
  -- Show error, no sprite active.
  local dlg = Dialog("Error")
  dlg:label {
    id = 0,
    text = "No sprite is currently active. Please, open a sprite first and run the script with it active."
  }
  dlg:newrow()
  dlg:button {
    id = 1,
    text = "Close",
    onclick = function()
      dlg:close()
    end
  }
  dlg:show()
  return
else
  -- Path where sprites are saved.
  local spritePath = sprite.filename

  -- Identify operating system.
  local separator
  if (string.sub(spritePath, 1, 1) == "/") then
    separator = "/"
  else
    separator = "\\"
  end

  local spriteName = getFileName(spritePath, separator)
  local path = getPath(spritePath, separator) .. spriteName .. separator

  -- User can Export or Cancel
  local dlg2 = Dialog("Export?")
  dlg2:label {
    id = 0,
    text = "Export with default settings as png? " .. path .. spriteName .. ".png"
  }
  dlg2:newrow()
  dlg2:button {
    id = 1,
    text = "Export",
    onclick = function()
      dlg2:close()
      exportSaveClose(path, spriteName)
    end
  }
  dlg2:button {
    id = 2,
    text = "Cancel",
    onclick = function()
      dlg2:close()
    end
  }
  dlg2:show()
end
