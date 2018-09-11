defmodule HsTest do
  use ExUnit.Case

  test "no questions" do
    assert {:ok, _tx_id, "851712"} = HS.describe_product("iphone")
  end

  test "one questions" do
    assert {:question, tx_id, int_id, question} = HS.describe_product("spoon")
    artifical_bait = HsTest.find_question_answer(question, "artificial bait")
    assert artifical_bait != nil
    assert {:ok, _tx_id, "950790"} = HS.answer_question(tx_id, int_id, %{"artificial bait" => artifical_bait.id})
  end

  test "multiple questions" do
    assert {:question, tx_id, int_id, question} = HS.describe_product("spoon")

    kitchen_or_table_utensil = HsTest.find_question_answer(question, "kitchen or table utensil")
    assert kitchen_or_table_utensil != nil
    assert {:question, tx_id, int_id, question} = HS.answer_question(tx_id, int_id, %{"kitchen or table utensil" => kitchen_or_table_utensil.id})

    base_metal = HsTest.find_question_answer(question, "base metal")
    assert base_metal != nil
    assert {:question, tx_id, int_id, question} = HS.answer_question(tx_id, int_id, %{"base metal" => base_metal.id})

    other = HsTest.find_question_answer(question, "other")
    assert other != nil
    assert {:ok, tx_id, "821599"} = HS.answer_question(tx_id, int_id, %{"other" => other.id})
  end

  def find_question_answer(question, answer_name) do
    Enum.find(question, nil, fn(q) -> q.name == answer_name end)
  end
end
