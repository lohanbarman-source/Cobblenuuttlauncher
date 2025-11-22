---@meta
--- Represents an event triggered when a player sends a chat message, containing details about the sender and message content.
--- This event can be canceled to prevent the message from being distributed.
---@class ChatMessageEvent
---@field name string @Read-Only The name of the event, identifying it as a chat message event.
---@field sender Player @Read-Only A reference to the player who sent the chat message.
---@field message string @Read-Only The content of the chat message.
ChatMessageEvent = {}
