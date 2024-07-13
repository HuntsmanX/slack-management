
require "logger"
activate_control_app
threads 4, 16
workers ENV.fetch("PUMA_WORKERS", 0)

preload_app!
