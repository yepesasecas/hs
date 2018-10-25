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

  def get_schedule_list(hs_code) do
    body = Census.get_schedule_list(hs_code)
    {:schedule_list, body}
  end

  def get_legal_notes(hs_code) do
    body = Census.get_legal_notes(hs_code)
    {:notes, body}
  end

  defp response_format(body) do
    case body do
      %{"hsCode" => hs_code} when hs_code != "" ->
        product = %{}
          |> Map.put(:hs_code, hs_code)
          |> Map.put(:current_item_name, body["currentItemName"])
          |> Map.put(:characteristics, %{assumed: body["assumedInteractions"], known: body["knownInteractions"]})
        {:ok, body["txId"], product}
      %{"currentItemName" => currentItemName} when currentItemName == "Unknown Item" ->
        product = %{}
          |> Map.put(:current_item_name, body["currentItemName"])
        {:error, body["txId"], product}
      _ ->
        product = %{}
          |> Map.put(:current_item_name, body["currentItemName"])
          |> Map.put(:characteristics, %{assumed: body["assumedInteractions"], known: body["knownInteractions"]})
          |> Map.put(:question, questions(body))
          |> Map.put(:label, body["currentQuestionInteraction"]["label"])
          |> Map.put(:type, body["currentQuestionInteraction"]["type"])
        {:question, body["txId"], body["currentQuestionInteraction"]["id"], product}
    end
  end

  defp questions(body) do
    body["currentQuestionInteraction"]["attrs"]
    |> Enum.reduce([], fn(x, acc) ->
      question = %{name: x["name"], id: x["id"], value: x["value"]}
      [question | acc]
    end)
  end
end
