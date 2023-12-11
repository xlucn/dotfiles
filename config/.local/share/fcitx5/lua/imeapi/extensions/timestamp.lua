function timestamp(input)
    return {
        os.date("%Y%m%d"),
        os.date("%Y%m%dT%H%M"),
        os.date("%Y%m%dT%H%M%S"),
    }
end

ime.register_command("dt", "timestamp", "ISO-like datatime", "digit", "")
ime.register_trigger("timestamp", "ISO-like datatime", {}, {'iso'})
