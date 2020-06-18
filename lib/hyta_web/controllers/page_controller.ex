defmodule HytaWeb.PageController do
  use HytaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
