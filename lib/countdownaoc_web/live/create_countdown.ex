defmodule CountdownaocWeb.CreateCountdown do
  use CountdownaocWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(CountdownaocWeb.CountdownDisplayView, "create.html", assigns)
  end
end
