import Config

config :hyta, HytaWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  http: [port: String.to_integer(System.fetch_env!("PORT"))],
  url: [
    host: System.get_env("HOST"),
    port: 443
  ]
