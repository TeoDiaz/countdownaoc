defmodule CountdownaocWeb.CountdownDisplay do
  use CountdownaocWeb, :live_view

  @minute 60
  @hour @minute * 60
  @day @hour * 24
  @week @day * 7
  @divisor [@week, @day, @hour, @minute, 1]
  @utc_offset @hour * 5

  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :tick)

    {:ok, get_remaining_time(socket)}
  end

  def render(assigns) do
    Phoenix.View.render(CountdownaocWeb.CountdownDisplayView, "countdown.html", assigns)
  end

  def handle_info(:tick, socket) do
    socket = get_remaining_time(socket)
    {:noreply, socket}
  end

  defp get_remaining_time(%{assigns: %{remaining_time: remaining_time}} = socket) do
    new_diff = remaining_time - 1
    assign(socket, remaining_time: new_diff, time: sec_to_str(new_diff))
  end

  defp get_remaining_time(socket) do
    d1 = %DateTime{
      year: 2021,
      month: 12,
      day: 3,
      zone_abbr: "RST",
      hour: 5,
      minute: 0,
      second: 0,
      utc_offset: 0,
      std_offset: 0,
      time_zone: "America/NewYork"
    }

    d2 = DateTime.utc_now()

    diff = DateTime.diff(d1, d2)

    assign(socket, remaining_time: diff, time: sec_to_str(diff))
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
