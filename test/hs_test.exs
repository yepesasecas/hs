defmodule HsTest do
  use ExUnit.Case

  test "no questions" do
    assert {:ok, _tx_id, product} = HS.describe_product("iphone")
    assert "851712" == product.hs_code
    assert "iPhone" == product.current_item_name
  end

  test "one questions" do
    assert {:question, tx_id, int_id, %{question: question, label: label, type: type}} = HS.describe_product("spoon")
    artificial_bait = HsTest.find_question_answer(question, "artificial bait")
    assert artificial_bait != nil
    assert label == "item"
    assert type == "SELECTION"
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
    assert {:question, tx_id, int_id, product} = HS.answer_question(tx_id, int_id, %{"kitchen or table utensil" => kitchen_or_table_utensil.id})
    assert "spoon" == product.current_item_name
    question = product.question

    base_metal = HsTest.find_question_answer(question, "base metal")
    assert base_metal != nil
    assert product.label == "composition"
    assert product.type == "SELECTION"
    assert {:question, tx_id, int_id, product} = HS.answer_question(tx_id, int_id, %{"base metal" => base_metal.id})
    assert "spoon" == product.current_item_name
    question = product.question

    other = HsTest.find_question_answer(question, "other")
    assert other != nil
    assert product.label == "coating"
    assert product.type == "SELECTION"
    assert {:ok, tx_id, product} = HS.answer_question(tx_id, int_id, %{"other" => other.id})
    assert "821599" == product.hs_code
    assert "spoon" == product.current_item_name
  end

  def find_question_answer(question, answer_name) do
    Enum.find(question, nil, fn(q) -> q.name == answer_name end)
  end
end
