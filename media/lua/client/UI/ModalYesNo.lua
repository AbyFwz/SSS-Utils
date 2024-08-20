require "SSS_Utils_Client"

-- Function to show a modal dialog with a button
function SSS:showModalDialog(btnText, onYesFn, param1, param2, param3)
    -- Create the modal dialog
    local modal = ISModalDialog:new(
        (getCore():getScreenWidth() / 2) - 130,
        (getCore():getScreenHeight() / 2) - 60,
        260,
        120,
        btnText,
        true,
        self,
        function(self, button)
            if button.internal == "YES" then
                onYesFn(button, param1, param2, param3)
            end
        end
    )

    -- Initialize and add modal to UI manager
    modal:initialise()
    modal:addToUIManager()

    return modal
end
