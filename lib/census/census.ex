defmodule Census do
  def describe_product(desc) do
    census_request_template()
      |> Map.put(:state, "start")
      |> Map.put(:proddesc, desc)
      |> Poison.encode!()
      |> run_request()
  end

  def answer_question(tx_id, int_id, answer) do
    [key | _] = Map.keys(answer)

    census_request_template()
      |> Map.merge(%{
        state: "continue",
        interactionid: int_id,
        txid: tx_id,
        values: [%{
          first: answer[key],
          second: key
        }],
      })
      |> Poison.encode!()
      |> run_request()
  end

  defp census_request_template do
    %{
      lang: "en",
      username: "NOT_SET",
      userData: "NO_DATA_AVAIL",
      destination: "US",
      origin: "US",
      proddesc: "spoon",
      profileId: "57471f0c4ac2c9b910000000"
    }
  end

  defp run_request(request) do
    {:ok, %HTTPoison.Response{body: body, headers: _headers}} = HTTPoison.post('https://uscensus.prod.3ceonline.com/ui/classify', request, [{"Content-Type", "application/json"}])
    Poison.decode!(body)
  end
end
