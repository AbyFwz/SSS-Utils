require "ISUI/ISWorldObjectContextMenu"

-- Store the original render function
local vanillaContextMenuRender = ISContextMenu.render

-- Override the render function
function ISContextMenu:render()
    -- Iterate through the options and update the icon texture based on mouse over state
    for i, option in ipairs(self.options) do
        if option.hoverIcon and self.mouseOver == i then
            option.iconTexture = option.hoverIcon
        elseif option.defaultIcon then
            option.iconTexture = option.defaultIcon
        end
    end

    -- Call the original render function
    vanillaContextMenuRender(self)
end
