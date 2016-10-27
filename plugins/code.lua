local function run(msg, matches)
  local text = matches[1]
    send_api_msg(msg.to.id, get_receiver_api(msg), "<code>"..text.."</code>", true, 'html')
end

return {
  description = "Reply Your Sent Message",
  usage = "/code (message) : reply message",
  patterns = {
    "^[!/#]code +(.+)$"
  }, 
	run = run,
	moderated = true
}
