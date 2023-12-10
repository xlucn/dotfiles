function timestamp(input)
    return os.date("%Y%m%dT%H%M")
end

ime.register_command("dt", "timestamp", "ISO-like datatime", "digit", "")
ime.register_trigger("timestamp", "ISO-like datatime", {}, {'iso'})
