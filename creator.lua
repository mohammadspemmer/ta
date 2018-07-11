db = dofile('./libs/redis.lua')
function jovetabidget()
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls')
	local last = 0
    for filename in pfile:lines() do
        if filename:match('jovetab%-(%d+)%.lua') and tonumber(filename:match('jovetab%-(%d+)%.lua')) >= last then
			last = tonumber(filename:match('jovetab%-(%d+)%.lua')) + 1
			end		
    end
    return last
end
local last = jovetabidget()
io.write("ایدی انتخاب شده خودکار : "..last)
io.write("\nایدی عددی سودو را وارد کنید : ")
local admin=io.read()
io.open("jovetab-"..last..".lua",'w'):write("jovetabnum = '"..last.."'\nfunction reload()\n\njovetab = dofile('jovetab.lua')\nend\nreload()"):close()
io.open("jovetab-"..last..".sh",'w'):write("while true; do\n$(dirname $0)/tg -p jovetab-"..last.." -s jovetab-"..last..".lua\nsleep 2\ndone"):close()
io.popen("chmod 777 jovetab-"..last..".sh")
db:sadd('bot'..last..'admin', admin)
print("ایدی سودو:"..admin.."")
