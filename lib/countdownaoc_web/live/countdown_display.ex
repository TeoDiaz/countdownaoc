defmodule CountdownaocWeb.CountdownDisplay do
  use CountdownaocWeb, :live_view

  @minute 60
  @hour @minute * 60
  @day @hour * 24
  @week @day * 7
  @divisor [@week, @day, @hour, @minute, 1]

  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :tick)

    socket = get_remaining_time(socket)

    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(CountdownaocWeb.CountdownDisplayView, "countdown.html", assigns)
  end

  def handle_info(:tick, socket) do
    socket = get_remaining_time(socket)
    {:noreply, socket}
  end

  defp get_remaining_time(socket) do
    d1 = %DateTime{
      year: 2021,
      month: 12,
      day: 1,
      zone_abbr: "RST",
      hour: 6,
      minute: 0,
      second: 0,
      utc_offset: 3600,
      std_offset: 0,
      time_zone: "Europe/Madrid"
    }

    d2 = DateTime.utc_now()

    %{week: week, day: day, hours: hours, minutes: minutes, seconds: seconds} =
      sec_to_str(DateTime.diff(d1, d2))

    assign(socket, w: week, d: day, h: hours, m: minutes, s: seconds)
  end

  defp sec_to_str(sec) when sec <= 0, do: %{week: 0, day: 0, hours: 0, minutes: 0, seconds: 0}

  defp sec_to_str(sec) do
    {_, [s, m, h, d, w]} =
      Enum.reduce(@divisor, {sec, []}, fn divisor, {n, acc} ->
        {rem(n, divisor), [div(n, divisor) | acc]}
      end)

    %{
      week: w,
      day: d,
      hours: h,
      minutes: m,
      seconds: s
    }
  end
end
