local tym = require('tym')

tym.set_config({
    autohide = true,
    bold_is_bright = true,
    silent = true,
})

tym.set_keymaps({
    ['<Ctrl>equal'] = function()
        tym.set('scale', tym.get('scale') + 10)
    end,
    ['<Ctrl>minus'] = function()
        tym.set('scale', tym.get('scale') - 10)
    end,
    ['<Ctrl>0'] = function()
        tym.set('scale', 100)
    end,
})

tym.set_hooks({
    ['clicked'] = function(button, uri)
        local ctrl = tym.check_mod_state('<Ctrl>')
        if button == 1 and uri and ctrl then
            tym.open(uri)
            return true
        end
    end,
})
