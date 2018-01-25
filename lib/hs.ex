defmodule HS do
  @moduledoc """
  Documentation for Hs.
  """

  def describe_product(desc) do
    case body = Census.describe_product(desc) do
      %{"hsCode" => hs_code} when hs_code != "" ->
        {:ok, body["txId"], hs_code}
      _ ->
        {:question, body["txId"], body["currentQuestionInteraction"]["id"], questions(body)}
    end
  end

  def answer_question(tx_id, int_id, answer) do
    case body = Census.answer_question(tx_id, int_id, answer) do
      %{"hsCode" => hs_code} when hs_code != "" ->
        {:ok, body["txId"], hs_code}
      _ ->
        {:question, body["txId"], body["currentQuestionInteraction"]["id"], questions(body)}
    end
  end

  defp questions(body) do
    body["currentQuestionInteraction"]["attrs"]
    |> Enum.reduce(%{}, fn(x, acc) ->
      Map.put(acc, x["name"], x["id"])
    end)
  end
end
