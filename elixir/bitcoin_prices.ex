defmodule Bitcoin do
  @endpoint "http://api.bitcoincharts.com/v1/trades.csv"

  def map_currencies(exchange, currencies) do
    currencies
    |> Enum.map(fn(currency) -> Task.async(fn -> display(exchange, currency) end) end)
    |> Enum.map(&Task.await/1)
  end

  def display(exchange, currency) do
    result = value_of exchange, currency
    case result |> is_float do
      true -> %{exchange: exchange, currency: currency, rate: result}
      _    -> %{exchange: exchange, currency: currency, error: result}
    end
  end

  defp value_of(exchange, currency) do
    endpoint_for(exchange, currency) |> HTTPoison.get! |> handle_response
  end

  defp handle_response(resp=%{status_code: code}) when code in 200..299, do: parse_price(resp.body)
  defp handle_response(%{status_code: code})      when code in 300..399, do: "BAD MARKET OR CURRENCY"
  defp handle_response(_), do: "BAD REQUEST"

  defp parse_price(body) do
    [_, price, _] = body |> String.split |> List.last |> String.split(",")
    price |> String.to_float |> Float.round(2)
  end

  defp endpoint_for(exchange, currency) do
    "#{@endpoint}?symbol=#{exchange}#{currency}"
  end
end

Bitcoin.display("rock", "USD") |> IO.inspect
Bitcoin.map_currencies("bitfinex", ["CAD", "USD", "GBP", "AUD", "DOG"]) |> IO.inspect
