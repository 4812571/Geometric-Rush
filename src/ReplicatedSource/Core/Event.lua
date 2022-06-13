local Event = {
    returns = {};
}
Event.__index = Event

function Event.new()
    local self = {
        params = {};
        bindable = Instance.new("BindableEvent");
    }

    return setmetatable(self, Event)
end

function Event:Fire(...)
    -- Pack the arguments into a table, and then fire the event.
    self.params = table.pack(...)
    self.bindable:Fire()
end

function Event:Connect(callback)
    -- A wrapper function that fetches the arguments from the table, and then calls the callback.
    local callbackWrapper = function() callback(table.unpack(self.params, 1, self.params.n)) end

    self.bindable.Event:Connect(callbackWrapper)
end

function Event:Wait(callback)
    -- Wait for the event to fire, then return the arguments.
    self.bindable.Event:Wait()
    return table.unpack(self.params, 1, self.params.n)
end

return Event