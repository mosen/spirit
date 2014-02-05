##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, '132b1d4db97a8742f2d2300bcfdbd22c192cd65fbaa2c0441bcc1613c82b3444'
  set :protection, true
  set :protect_from_csrf, true
end

# Mounts the core application for this project
Padrino.mount('Spirit::App', :app_file => Padrino.root('app/app.rb')).to('/')
