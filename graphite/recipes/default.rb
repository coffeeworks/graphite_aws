include_recipe "python"
include_recipe "logrotate"

include_recipe "graphite::whisper"
include_recipe "graphite::carbon"
include_recipe "graphite::dashboard"
