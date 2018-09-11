defmodule HS do
  @moduledoc """
  Documentation for Hs.
  """

  def describe_product(desc) do
    Census.describe_product(desc)
    |> response_format()
  end

  def answer_question(tx_id, int_id, answer) do
    Census.answer_question(tx_id, int_id, answer)
    |> response_format()
  end

  defp response_format(body) do
    case body do
      %{"hsCode" => hs_code} when hs_code != "" ->
        {:ok, body["txId"], hs_code}
      _ ->
        {:question, body["txId"], body["currentQuestionInteraction"]["id"], questions(body)}
    end
  end

  defp questions(body) do
    body["currentQuestionInteraction"]["attrs"]
    |> Enum.reduce([], fn(x, acc) ->
      question = %{name: x["name"], id: x["id"]}
      [question | acc]
    end)
  end
end
