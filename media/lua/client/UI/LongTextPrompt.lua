require "SSS_Utils_Client"

-- Function to show a long text prompt
function SSS:showLongTextPrompt(text, defaultValue, btnFn)
    local w = 500
    local h = 350

    -- Create the modal text box
    local modal = ISTextBox:new(
        (getCore():getScreenWidth() / 2) - (w / 2),
        (getCore():getScreenHeight() / 2) - (h / 2),
        w, h,
        text,
        tostring(defaultValue),
        self,
        function(self, button)
            if button.internal == "OK" then
                if btnFn then
                    btnFn(button.parent.entry:getText())
                end
            end
        end,
        nil
    )

    -- Set modal properties
    modal.numLines = 14
    modal.maxLines = 1000
    modal.multipleLine = true

    -- Initialize and add modal to UI manager
    modal:initialise()
    modal:addToUIManager()

    return modal
end
