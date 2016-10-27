local function run(msg, matches)
local htp = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[1])..'&text='..URL.escape(matches[2]))
local data = json:decode(htp)
local text = 'زبان : *'..data.lang..'*\nمعنی : *'..data.text[1]..'*\n[Beyond Team](Telegram.Me/BeyondTeam)'
return send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
end
return {
  patterns = {
    "^[!#/][Tt]r ([^%s]+) (.*)$"
  },
  run = run
}
