
local function run(msg, matches)
  local text = matches[1]
    send_api_msg(msg.to.id, get_receiver_api(msg), "<i>"..text.."</i>", true, 'html')
end

return {
  description = "Reply Your Sent Message",
  usage = "/echo (message) : reply message",
  patterns = {
    "^[!/#]italic +(.+)$"
  }, 
	run = run,
	moderated = true
}
