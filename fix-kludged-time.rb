def kludge_time_from_bogusZ_to_utc(pst_in_utc_str)
  pst_in_utc = Time.parse(pst_in_utc_str)
  old_tz = ENV['TZ']
  ENV['TZ'] = 'America/Vancouver'
  t = Time.local(
    pst_in_utc.year,
    pst_in_utc.month,
    pst_in_utc.day,
    pst_in_utc.hour,
    pst_in_utc.min,
    pst_in_utc.sec
  )
  # https://github.com/rtanglao/rt-kits-api3/issues/1
  fixed_time =
    if t.dst?
      Time.parse(pst_in_utc_str.gsub('Z', 'PDT'))
    else
      Time.parse(pst_in_utc_str.gsub('Z', 'PST'))
    end
  ENV['TZ'] = old_tz
  fixed_time
end
