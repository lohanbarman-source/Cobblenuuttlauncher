---@meta
--- Represents an interceptor for events.
---
--- An EventInterceptor is returned by `spell:intercept()` and allows inline handling of events as they occur.
--- Unlike an EventQueue, an interceptor can cancel events by returning `false` from its callback function (if the event supports cancellation).
---
--- ### Example: Canceling a death event
--- ```lua
--- local i = spell:intercept({ "BeforeLivingEntityDeathEvent" }, function(evt)
---   if evt.entity.type.id == "zombie" then
---     evt.entity.health = 1
---     return false  -- Cancel the death
---   end
---   return true
--- end)
---
--- while true do sleep(20) end  -- Keep spell running
--- ```
---@class EventInterceptor
---@field names table @Read-Only The names of the events that this interceptor listens to.
EventInterceptor = {}

--- Stops this interceptor from receiving further events.
---
--- ### Example: Stopping on a specific message
--- ```lua
--- local i = spell:intercept({"ChatMessageEvent"}, function(evt)
---   if evt.message == "stop" then
---     i:stop()  -- Disable further interception
---   end
--- end)
--- ```
function EventInterceptor:stop()
end
