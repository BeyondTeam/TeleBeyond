local database = 'http://vip.opload.ir/vipdl/95/1/amirab248/'
local function run(msg)
 local res = http.request(database.."jomlak.db")
 local jomlak = res:split(",") 
 local text = jomlak[math.random(#jomlak)]..'\n\n@BeyondTeam'
return reply_msg(msg.id, text, ok_cb, false)
end
return {
 patterns = {
  "^[!/#][Jj][Oo][Mm][Ll][Aa][Kk]$"
  },
 run = run
}
