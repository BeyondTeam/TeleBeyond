local function run(msg, matches)
        local text = URL.escape(matches[1])
        local color = 'blue'
        if matches[2] == 'red' then
            color = 'red'
        elseif matches[2] == 'black' then
            color = 'black'
      elseif matches[2] == 'blue' then
          color = 'blue'
    elseif matches[2] == 'green' then
        color = 'green'
    elseif matches[2] == 'yellow' then
        color = 'yellow'
    elseif matches[2] == 'pink' then
        color = 'magenta'
    elseif matches[2] == 'orange' then
        color = 'Orange'
    elseif matches[2] == 'brown' then
        color = 'DarkOrange'
        end
        local font = 'mathrm'
        if matches[3] == 'bold' then
            font = 'mathbf'
        elseif matches[3] == 'italic' then
            font = 'mathit'
        elseif matches[3] == 'fun' then
            font = 'mathfrak'
        elseif matches[1] == 'arial' then
            font = 'mathrm'
        end
        local size = '700'
        if matches[4] == 'small' then 
            size = '300'
        elseif matches[4] == 'larg' then
            size = '700'
            end
local url = 'http://latex.codecogs.com/png.latex?'..'\\dpi{'..size..'}%20\\huge%20\\'..font..'{{\\color{'..color..'}'..text..'}}'
local file = download_to_file(url,'file.webp')
if msg.to.type == 'channel' then
send_document('channel#id'..msg.to.id,file,ok_cb,false)
else
send_document('chat#id'..msg.to.id,file,ok_cb,false)
end
end
return {
   patterns = {
       "^[/!#]sticker (.*) ([^%s]+) (.*) (small)$",
       "^[/!#]sticker (.*) ([^%s]+) (.*) (larg)$",
       "^[/!#]sticker (.*) ([^%s]+) (bold)$",
 "^[/!#]sticker (.*) (bold)$",
       "^[/!#]sticker (.*) ([^%s]+) (italic)$",
       "^[/!#]sticker (.*) ([^%s]+) (fun)$",
       "^[/!#]sticker (.*) ([^%s]+) (arial)$",
       "^[/!#]sticker (.*) (red)$",
       "[/!#]sticker (.*) (black)$",
       "^[/!#]sticker (.*) (blue)$",
       "^[/!#]sticker (.*) (green)$",
       "^[/!#]sticker (.*) (yellow)$",
       "^[/!#]sticker (.*) (pink)$",
       "^[/!#]sticker (.*) (orange)$",
       "^[/!#]sticker (.*) (brown)$",
       "^[/!#]sticker +(.*)$",
       },
   run = run
}