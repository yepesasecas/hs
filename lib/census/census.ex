defmodule Census do
  def describe_product(desc) do
    data = Poison.encode!(%{
      state: "start",
      proddesc: desc,
      lang: "en",
      username: "NOT_SET",
      userData: "NO_DATA_AVAIL",
      destination: "US",
      origin: "US",
      profileId: "57471f0c4ac2c9b910000000"
    })

    {:ok, %HTTPoison.Response{body: body, headers: headers}} = HTTPoison.post('https://uscensus.prod.3ceonline.com/ui/classify', data, [{"Content-Type", "application/json"}])
    Poison.decode!(body)
  end

  def answer_question(tx_id, int_id, answer) do
    [key | _] = Map.keys(answer)

    data = Poison.encode!(%{
      state: "continue",
      interactionid: int_id,
      txid: tx_id,
      values: [%{
        first: answer[key],
        second: key
      }],
      username: "NOT_SET",
      userData: "NO_DATA_AVAIL",
      destination: "US",
      origin: "US",
      proddesc: "spoon",
      profileId: "57471f0c4ac2c9b910000000"
    })

    {:ok, %HTTPoison.Response{body: body, headers: headers}} = HTTPoison.post('https://uscensus.prod.3ceonline.com/ui/classify', data, [{"Content-Type", "application/json"}])
    Poison.decode!(body)
  end
end
