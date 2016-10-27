local database = 'http://vip.opload.ir/vipdl/94/11/amirhmz/'
local function run(msg)
if is_momod(msg) then
	local res = http.request(database.."joke.db")
	local joke = res:split(",") 
	local text = joke[math.random(#joke)]..'\n\n@BeyondTeam️'
  return reply_msg(msg.id, text, ok_cb, false)
end
end
return {
	description = "500 Persian Joke",
	usage = "!joke : send random joke",
	patterns = {
		"^[!/]joke$",
		"^(joke)$"
		},
	run = run
}
