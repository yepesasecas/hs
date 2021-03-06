defmodule HsTest do
  use ExUnit.Case

  test "no questions" do
    assert {:ok, _tx_id, product} = HS.describe_product("iphone")
    assert "851712" == product.hs_code
    assert "iPhone" == product.current_item_name
    assert [:assumed, :known] == Map.keys(product.characteristics)
  end

  test "one questions" do
    assert {:question, tx_id, int_id, %{question: question, label: label, type: type, characteristics: characteristics}} = HS.describe_product("spoon")
    artificial_bait = HsTest.find_question_answer(question, "artificial bait")
    assert artificial_bait != nil
    assert label == "item"
    assert type == "SELECTION"
    assert [:assumed, :known] == Map.keys(characteristics)
    assert {:ok, _tx_id, product} = HS.answer_question(tx_id, int_id, %{"artificial bait" => artificial_bait.id})
    assert "950790" == product.hs_code
    assert "artificial bait" == product.current_item_name
  end

  test "multiple questions" do
    assert {:question, tx_id, int_id, product} = HS.describe_product("spoon")
    question = product.question

    kitchen_or_table_utensil = HsTest.find_question_answer(question, "kitchen or table utensil")
    assert kitchen_or_table_utensil != nil
    assert product.label == "item"
    assert product.type == "SELECTION"
    assert [:assumed, :known] == Map.keys(product.characteristics)
    assert {:question, tx_id, int_id, product} = HS.answer_question(tx_id, int_id, %{"kitchen or table utensil" => kitchen_or_table_utensil.id})
    assert "spoon" == product.current_item_name
    question = product.question

    base_metal = HsTest.find_question_answer(question, "base metal")
    assert base_metal != nil
    assert product.label == "composition"
    assert product.type == "SELECTION"
    assert [:assumed, :known] == Map.keys(product.characteristics)
    assert {:question, tx_id, int_id, product} = HS.answer_question(tx_id, int_id, %{"base metal" => base_metal.id})
    assert "spoon" == product.current_item_name
    question = product.question

    other = HsTest.find_question_answer(question, "other")
    assert other != nil
    assert product.label == "coating"
    assert product.type == "SELECTION"
    assert [:assumed, :known] == Map.keys(product.characteristics)
    assert {:ok, tx_id, product} = HS.answer_question(tx_id, int_id, %{"other" => other.id})
    assert "821599" == product.hs_code
    assert "spoon" == product.current_item_name
  end

  test "valued question" do
    assert {:question, tx_id, int_id, product} = HS.describe_product("tshirt")
    tshirt = HsTest.find_question_answer(product.question, "babies'")
    assert {:valued_question, tx_id, int_id, product} = HS.answer_question(tx_id, int_id, %{"babies'" => tshirt.id})
    assert product.label == "composition"
    assert product.type == "VALUED"
    assert {:ok, tx_id, product} = HS.answer_valued_question(tx_id, int_id, format_valued_question(product.question, %{"cotton" => "80", "synthetic fibre" => "20", "other textile material" => "0"}))
    assert "611120" == product.hs_code
  end

  def format_valued_question(question, compositon) do
    question
    |> Enum.reduce([], fn(q, acc) ->
      [%{first: compositon[q.name], second: q.id} | acc]
    end)
  end

  def find_question_answer(question, answer_name) do
    Enum.find(question, nil, fn(q) -> q.name == answer_name end)
  end
end
