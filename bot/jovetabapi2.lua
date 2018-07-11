local URL = require "socket.url"
local https = require "ssl.https"
local serpent = require "serpent"
local json = (loadfile "./libs/JSON.lua")()
local token = '419567235:AAFgNkZaNYYXs7-_oTFyPtIKyEd0AXNnGa4' --token
local url = 'https://api.telegram.org/bot' .. token
local offset = 0
local redis = require('redis')
local redis = redis.connect('127.0.0.1', 6379)
local SUDO = 123456789
function is_mod(chat,user)
sudo = {123456789}
  local var = false
  for v,_user in pairs(sudo) do
    if _user == user then
      var = true
    end
  end
 local hash = redis:sismember(SUDO..'owners:'..chat,user)
 if hash then
 var = true
 end
 local hash2 = redis:sismember(SUDO..'mods:'..chat,user)
 if hash2 then
 var = true
 end
 return var
 end
local function getUpdates()
  local response = {}
  local success, code, headers, status  = https.request{
    url = url .. '/getUpdates?timeout=20&limit=1&offset=' .. offset,
    method = "POST",
    sink = ltn12.sink.table(response),
  }

  local body = table.concat(response or {"no response"})
  if (success == 1) then
    return json:decode(body)
  else
    return nil, "Request Error"
  end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function sendmsg(chat,text,keyboard)
if keyboard then
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text=' ..URL.escape(text)..'&parse_mode=html'
end
https.request(urlk)
end
 function edit( message_id, text, keyboard)
  local urlk = url .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end
function settings(chat,value) 
local hash = SUDO..'settings:'..chat..':'..value
  if value == 'file' then
      text = 'فیلتر فایل'
   elseif value == 'keyboard' then
    text = 'فیلتردرون خطی(کیبرد شیشه ای)'
  elseif value == 'link' then
    text = 'قفل ارسال لینک(تبلیغات)'
  elseif value == 'game' then
    text = 'فیلتر انجام بازی های(inline)'
    elseif value == 'username' then
    text = 'قفل ارسال یوزرنیم(@)'
	elseif value == 'hashtag' then
    text = 'ارسال هشتگ(#)'
   elseif value == 'pin' then
    text = 'قفل پین کردن(پیام)'
    elseif value == 'photo' then
    text = 'فیلتر تصاویر'
    elseif value == 'gif' then
    text = 'فیلتر تصاویر متحرک'
    elseif value == 'video' then
    text = 'فیلتر ویدئو'
    elseif value == 'audio' then
    text = 'فیلتر صدا(audio-voice)'
    elseif value == 'music' then
    text = 'فیلتر آهنگ(MP3)'
    elseif value == 'text' then
    text = 'فیلتر متن'
    elseif value == 'sticker' then
    text = 'قفل ارسال برچسب'
    elseif value == 'contact' then
    text = 'فیلتر مخاطبین'
    elseif value == 'forward' then
    text = 'فیلتر فوروارد'
    elseif value == 'persian' then
    text = 'فیلتر گفتمان(فارسی)'
    elseif value == 'english' then
    text = 'فیلتر گفتمان(انگلیسی)'
    elseif value == 'bot' then
    text = 'قفل ورود ربات(API)'
    elseif value == 'tgservice' then
    text = 'فیلتر پیغام ورود،خروج افراد'
    end
		if not text then
		return ''
		end
	if redis:get(hash) then
  redis:del(hash)
return text..'  غیرفعال شد.'
		else 
		redis:set(hash,true)
return text..'  فعال شد.'
end
    end
function fwd(chat_id, from_chat_id, message_id)
  local urlk = url.. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id
  local res, code, desc = https.request(urlk)
  if not res and code then --if the request failed and a code is returned (not 403 and 429)
  end
  return res, code
end
function sleep(n) 
os.execute("sleep " .. tonumber(n)) 
end
local day = 86400
local function run()
  while true do
    local updates = getUpdates()
    vardump(updates)
    if(updates) then
      if (updates.result) then
        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
						if q.query:match('s(%d+)') then
              local chat = '-'..q.query:match('s(%d+)')
			  local boti = q.query:match('s(%d+)')
			  local botid = redis:get("bot"..boti.."id")
if q.from.id == 218722292 or q.from.id == tonumber(botid) then
	local firstname = redis:get("bot"..boti.."fname")
	local lastname = redis:get("bot"..boti.."lanme")
	local number = redis:get("bot"..boti.."num")
	local realm = redis:get("realm")
	if redis:get(boti.."fwdtime") then
	fwdtime = '[🔹|فعال]'
	else
	fwdtime = '[🔸|غیرفعال]'
	end
local pm = redis:get(boti..'pm')
if not pm then
pm = 'اد شدی گلم پی وی نقطه بزار ❤️'
end
local typingt = redis:get(boti..'typingt')
if not typingt then
typingt = '3'
end
 if redis:get(boti..'savecontact') then
              co = '[🔹|فعال]'
            else
              co = '[🔸|غیرفعال]'
            end
if not redis:get(boti.."offlink") then
 oklink = 'فعال'
 else
 oklink = 'غیرفعال'
 end
 if redis:get(boti.."link") then
 findlink = 'فعال'
 else
 findlink = 'غیرفعال'
 end
 if not redis:get(boti..'offjoin') then
              join = '[🔹|فعال]'
            else
              join = '[🔸|غیرفعال]'
            end
 if redis:get(boti..'typing') then
              typing = '[🔹|فعال]'
            else
              typing = '[🔸|غیرفعال]'
            end
 if redis:get(boti..'addcontact') then
              addcontact = 'فعال'
            else
              addcontact = 'غیرفعال'
            end
if redis:get(boti..'maxgroups') then
 maxgroups = redis:get(boti..'maxgroups')
 else
 maxgroups = '0'
 end
 if redis:get(boti..'maxgpmmbr') then
 minmember = redis:get(boti..'maxgpmmbr')
 else
 minmember = '0'
 end
 if redis:get(boti..'markread') then
              markread = '[🔹|فعال]'
            else
              markread = '[🔸|غیرفعال]'
            end
if redis:get(boti.."autoanswer") then
autoanswer = '[🔹|فعال]'
else
autoanswer = '[🔸|غیرفعال]'
end
local fwdtimen = redis:get(boti..'fwdtimen')
if not fwdtimen then
fwdtimen = '4'
end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'عضویت خودکار♻️', callback_data = 'join'},
		{text = ''..join..'', callback_data = 'SGPS'}
				  },{
				{text = 'فرایند شناسایی لینک '..findlink..' است', callback_data = 'findlink'}
				},{
				{text = 'فرایند تایید لینک '..oklink..' است', callback_data = 'oklink'}
				},{
				{text = 'حداکثر گروه ژوپیتر تب '..maxgroups..' است', callback_data = 'maxgroup'}
				},{
				{text = 'حداقل اعضای گروه '..minmember..' است', callback_data = 'minmember'}
				}
				,{
				{text = 'افزودن مخاطبان💈', callback_data = 'co'},
		{text = ''..co..'', callback_data = 'cos'}
				}
				,{
				{text = 'پیام افزودن:'..pm..'', callback_data = 'pm'}
				}
				,{
				{text = 'اشتراک شماره هنگام افزودن '..addcontact..' است', callback_data = 'addcontacts'}
				}
				,{
				{text = 'ارسال زمانی🔭', callback_data = 'fwdtime'},
		{text = ''..fwdtime..'', callback_data = 'fwdtimes'}
				},{
				{text = 'تعداد گروه ارسالی در 3 ثانیه '..fwdtimen..'گروه میباشد', callback_data = 'fwdtimen'}
				},{
				{text = 'وضعیت مشاهده👁', callback_data = 'markread'},
		{text = ''..markread..'', callback_data = 'markreads'}
				},{
				{text = 'نوشتن🖊', callback_data = 'TYPING'},
		{text = ''..typing..'', callback_data = 'TYPINGS'}
				},{
				{text = 'زمان نوشتن ربات '..typingt..' ثانیه میباشد', callback_data = 'TTYPING'}
				},{
				{text = 'پاسخگوی خودکار🔈', callback_data = 'autoanswer'},
		{text = ''..autoanswer..'', callback_data = 'autoanswers'}
				},
				{
		{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'}
		}
							}
            answer(q.id,'settings','تنظیمات ژوپیتر تب '..boti,realm,'🌾به لیست تنظیمات ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..botid..'\n🏅نام ربات: '..firstname..'\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam',keyboard)
            end
            end
			if q.query:match('p(%d+)') then
              local chat = '-'..q.query:match('p(%d+)')
			  local boti = q.query:match('p(%d+)')
			  local botid = redis:get("bot"..boti.."id")
if q.from.id == 218722292 or q.from.id == tonumber(botid) then
	local firstname = redis:get("bot"..boti.."fname")
	local lastname = redis:get("bot"..boti.."lanme")
	local number = redis:get("bot"..boti.."num")
	local realm = redis:get("realm")
	local s =  redis:get(boti.."offjoin") and 0 or redis:get(boti.."maxjoin") and redis:ttl(boti.."maxjoin") or 0
local ss = redis:get(boti.."offlink") and 0 or redis:get(boti.."maxlink") and redis:ttl(boti.."maxlink") or 0
local gps = redis:scard(boti.."tsgps") or 0
local user = redis:scard(boti.."tusers")
local gp = redis:scard(boti.."tgp") or 0
local com = redis:scard(boti.."tcom") or 0
local block = redis:scard(boti.."tblock") or 0
local allmsg = redis:get(boti.."tallmsg") or 0
local joinlink = redis:scard(boti.."goodlinks") or 0 
local oklink = redis:scard(boti.."waitelinks") or 0
local savelink = redis:scard(boti.."savedlinks") or 0
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'کل پیام ها🏵', callback_data = 'join'},
		{text = ''..allmsg..'', callback_data = 'SGPS'}
				  },{
				{text = 'سوپرگروه ها🎭', callback_data = 'co'},
		{text = ''..gps..'', callback_data = 'cos'}
				},{
				{text = 'گروه ها👥', callback_data = 'fwdtime'},
		{text = ''..gp..'', callback_data = 'fwdtimes'}
				},{
				{text = 'کاربران👤', callback_data = 'markread'},
		{text = ''..user..'', callback_data = 'markreads'}
				},{
				{text = 'مسدود شده ها🚫', callback_data = 'TYPING'},
		{text = ''..block..'', callback_data = 'TYPINGS'}
				}
				,{
				{text = 'لینک های عضویت♻️', callback_data = 'JoinLink'},
		{text = ''..joinlink..'', callback_data = 'JoinLinks'}
				}
				,{
				{text = 'لینک های تایید شده🔰', callback_data = 'oklink'},
		{text = ''..oklink..'', callback_data = 'oklinks'}
				}
				,{
				{text = 'لینک های ذخیره شده💾', callback_data = 'savelink'},
		{text = ''..savelink..'', callback_data = 'savelinks'}
				}
				,{
				{text = ''..s..' ثانیه تا عضویت مجدد', callback_data = 'savelink'}
				},{
				{text = ''..ss..' ثانیه تا تایید لینک مجدد', callback_data = 'savelink'}
				},{
				{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'}
				}
							}
            answer(q.id,'panel','آمار ژوپیتر تب '..boti,realm,'🌾به لیست آمار ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..boti..'\n🏅نام ربات: '..firstname..'\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam',keyboard)
            end
            end
end
       
      end
    end
  end
    end
end

return run()
