---@meta
--- Represents a queue that collects and manages events, providing methods to access the latest event, wait for the next event, or stop collection.
---@class EventQueue
---@field names table @Read-Only The names of the events that this queue is collecting.
EventQueue = {}

--- Returns the newest event in this queue and discards all older events.
--- If the queue is empty, `nil` is returned.
--- Use this method when only the most recent event is relevant, such as in updates.
---
--- ### Example
--- ```lua
--- local queue = Events.collect("ChatMessageEvent")
--- while true do
---   local event = queue:latest()
---   if event ~= nil then
---     spell:execute("say %s", event.message)
---   end
---   sleep(5 * 20)
--- end
--- ```
---@return any event The latest event or `nil` if the queue is empty.
function EventQueue:latest()
end

--- Returns the next event in the queue, blocking until an event is available or the specified timeout (in game ticks) is reached.
--- If no timeout is provided, this method blocks indefinitely until an event is available.
---
--- ### Example
--- ```lua
--- local queue = Events.collect("ChatEvent")
--- while true do
---   local event = queue:next()
---   spell:execute("say %s", event.message)
--- end
--- ```
---@param timeout number|nil Optional timeout in game ticks. If not provided, blocks indefinitely.
---@return any event The next event or `nil` if the timeout is reached.
function EventQueue:next(timeout)
end

--- Stops the queue from collecting events, preventing further additions to it.
---
--- ### Example
--- ```lua
--- local respawnQueue = spell:collect("AfterPlayerRespawnEvent")
--- spell:intercept({"ChatMessageEvent"}, function(evt)
---   if evt.message == "stop" then
---     respawnQueue:stop()
---   end
--- end)
--- while true do
---   local evt = respawnQueue:next(10)
---   if evt then
---     print(evt.newPlayer.name.." respawned")
---   end
--- end
--- ```
function EventQueue:stop()
end
