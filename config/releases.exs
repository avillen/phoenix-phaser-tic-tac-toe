import Config

config :hyta, HytaWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  http: [port: String.to_integer(System.fetch_env!("HTTP_PORT"))],
  url: [
    host: System.get_env("HOST"),
    port: String.to_integer(System.fetch_env!("URL_PORT"))
  ]
