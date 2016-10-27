local function run(msg, matches)
  local text = matches[1]
    send_api_msg(msg.to.id, get_receiver_api(msg), "<b>"..text.."</b>", true, 'html')
end

return {
  description = "Reply Your Sent Message",
  usage = "/echo (message) : reply message",
  patterns = {
    "^[!/#]bold +(.+)$"
  }, 
	run = run,
	moderated = true
}
