require "SSS_Utils_Client"

-- Function to show a modal info dialog
function SSS:showModalInfo(text)
    -- Create the modal dialog
    local modal = ISModalDialog:new(
        (getCore():getScreenWidth() / 2) - 130,
        (getCore():getScreenHeight() / 2) - 60,
        260, 120,
        text,
        false,
        self
    )

    -- Initialize and add modal to UI manager
    modal:initialise()
    modal:addToUIManager()

    return modal
end
