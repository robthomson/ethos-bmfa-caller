local BASE   = "SCRIPTS:/bmfa-caller/"
local SOUNDS = BASE .. "categories/"

local function loadDisc(name)
    local chunk = loadfile(SOUNDS .. name .. "/sequences.lua")
    return chunk and chunk() or nil
end

local DISCIPLINES = {}
local entries = system.listFiles(SOUNDS)
if entries then
    table.sort(entries)
    for _, entry in ipairs(entries) do
        local disc = loadDisc(entry)
        if disc then DISCIPLINES[#DISCIPLINES + 1] = disc end
    end
end

local function currentSeq(widget)
    local disc = DISCIPLINES[widget.discIdx] or DISCIPLINES[1]
    local cert = disc.certs[widget.certIdx] or disc.certs[1]
    return {disc = disc, cert = cert}
end

local function playMnvr(widget, idx)
    local s = currentSeq(widget)
    if idx >= 1 and idx <= #s.cert.seq then
        system.playFile(SOUNDS .. s.disc.key .. "/" .. s.cert.key .. "/" .. s.cert.seq[idx].file .. ".wav")
    end
end

local function resetSeq(widget)
    local s = currentSeq(widget)
    widget.mnvrIdx = 0
    system.playFile(SOUNDS .. s.disc.key .. "/" .. s.cert.key .. "/rst.wav")
    lcd.invalidate()
end

local function paint(widget)
    local s    = currentSeq(widget)
    local seq  = s.cert.seq
    local w, h = lcd.getWindowSize()

    if     h < 50  then lcd.font(FONT_XS)
    elseif h < 80  then lcd.font(FONT_S)
    elseif h > 170 then lcd.font(FONT_XL)
    else               lcd.font(FONT_STD) end

    local tw, th = lcd.getTextSize("")
    local bx, by = 4, th
    local bw, bh = w - 8, h - th - 4
    local total  = #seq
    local pct    = widget.mnvrIdx > 0
                   and math.floor(widget.mnvrIdx / total * 100) or 0
    local bar    = math.max(2, math.floor((bw - 2) * pct / 100) + 2)

    lcd.color(lcd.RGB(40, 40, 40))
    lcd.drawFilledRectangle(bx, by, bw, bh)
    lcd.color(lcd.RGB(0, 120, 200))
    lcd.drawFilledRectangle(bx, by, bar, bh)
    lcd.color(GREEN)
    lcd.drawRectangle(bx, by, bw, bh)
    lcd.color(WHITE)
    lcd.drawText(bx + bw / 2, by + bh * 0.10,
        s.disc.name .. "  " .. s.cert.name, CENTERED)

    if widget.mnvrIdx > 0 then
        local m = seq[widget.mnvrIdx]
        lcd.drawText(bx + bw / 2, by + bh * 0.42,
            widget.mnvrIdx .. " / " .. total, CENTERED)
        lcd.drawText(bx + bw / 2, by + bh * 0.70, m.label, CENTERED)
    else
        lcd.drawText(bx + bw / 2, by + bh * 0.45, "Ready", CENTERED)
    end
end

local function wakeup(widget)
    local trigNow = widget.trigSwitch and widget.trigSwitch:state() or false
    if trigNow and not widget.trigActive then
        local seq = currentSeq(widget).cert.seq
        widget.mnvrIdx = widget.mnvrIdx + 1
        if widget.mnvrIdx > #seq then
            resetSeq(widget)
        else
            playMnvr(widget, widget.mnvrIdx)
            lcd.invalidate()
        end
    end
    widget.trigActive = trigNow

    local rstNow = widget.rstSwitch and widget.rstSwitch:state() or false
    if rstNow and not widget.rstActive then
        resetSeq(widget)
    end
    widget.rstActive = rstNow

    local repNow = widget.repSwitch and widget.repSwitch:state() or false
    if repNow and not widget.repActive and widget.mnvrIdx > 0 then
        playMnvr(widget, widget.mnvrIdx)
    end
    widget.repActive = repNow
end

local function configure(widget)
    local discChoices = {}
    for i, disc in ipairs(DISCIPLINES) do
        discChoices[i] = {disc.name, i}
    end

    local certField
    local line = form.addLine("Category")
    form.addChoiceField(line, nil, discChoices,
        function() return widget.discIdx end,
        function(v)
            widget.discIdx = v
            widget.certIdx = 1
            widget.mnvrIdx = 0
            if certField then
                local choices = {}
                for i, cert in ipairs(DISCIPLINES[v].certs) do
                    choices[i] = {cert.name, i}
                end
                certField:values(choices)
            end
        end)

    local disc = DISCIPLINES[widget.discIdx] or DISCIPLINES[1]
    local certChoices = {}
    for i, cert in ipairs(disc.certs) do
        certChoices[i] = {cert.name, i}
    end
    line = form.addLine("Certificate")
    certField = form.addChoiceField(line, nil, certChoices,
        function() return widget.certIdx end,
        function(v) widget.certIdx = v; widget.mnvrIdx = 0 end)

    line = form.addLine("Trigger Switch")
    form.addSwitchField(line, form.getFieldSlots(line)[0],
        function() return widget.trigSwitch end,
        function(v) widget.trigSwitch = v end)

    line = form.addLine("Repeat Switch")
    form.addSwitchField(line, form.getFieldSlots(line)[0],
        function() return widget.repSwitch end,
        function(v) widget.repSwitch = v end)

    line = form.addLine("Reset Switch")
    form.addSwitchField(line, form.getFieldSlots(line)[0],
        function() return widget.rstSwitch end,
        function(v) widget.rstSwitch = v end)
end

local function read(widget)
    widget.discIdx    = storage.read("discIdx")    or widget.discIdx
    widget.certIdx    = storage.read("certIdx")    or widget.certIdx
    widget.trigSwitch = storage.read("trigSwitch") or widget.trigSwitch
    widget.rstSwitch  = storage.read("rstSwitch")  or widget.rstSwitch
    widget.repSwitch  = storage.read("repSwitch")  or widget.repSwitch
end

local function write(widget)
    storage.write("discIdx",    widget.discIdx)
    storage.write("certIdx",    widget.certIdx)
    storage.write("trigSwitch", widget.trigSwitch)
    storage.write("rstSwitch",  widget.rstSwitch)
    storage.write("repSwitch",  widget.repSwitch)
end

return {
    paint     = paint,
    wakeup    = wakeup,
    configure = configure,
    read      = read,
    write     = write,
}
