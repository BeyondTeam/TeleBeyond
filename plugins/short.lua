local function run(msg, matches)
  local urll = string.gsub(matches[1],'http://',"")
  local urll = string.gsub(matches[1],'https://',"")
  local url = URL.escape('http://'..urll)
  local yon = http.request('http://api.yon.ir/?url='..url)
  local jdat = json:decode(yon)
  local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..url)
  local data = json:decode(bitly)
  local yeo = http.request('http://yeo.ir/api.php?url='..url..'=')
  local opizo = http.request('http://api.gpmod.ir/shorten/?url='..url..'&username=aminaleahmad@yahoo.com')
  local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..url)
  local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..url..'&format=simple')

    local textpm = ' لینک اصلی :\n'
    ..data.data.long_url
    ..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n'
    ..'کوتاه شده با bitly :\n___________________________\n'
    ..data.data.url
    ..'\n___________________________\nکوتاه شده با yeo :\n'
    ..yeo
    ..'\n___________________________\nکوتاه شده با اوپیزو :\n'
    ..opizo
    ..'\n___________________________\nکوتاه شده با u2s :\n'
    ..u2s
    ..'\n___________________________\nکوتاه شده با llink : \n'
    ..llink
    ..'\n___________________________\nلینک کوتاه شده با yon : \nyon.ir/'
    ..jdat.output
    return textpm
end
return {
  patterns = {
    "^[!#/][Ss][Hh][Oo][Rr][Tt] (.*)$"
  },
  run = run
}
