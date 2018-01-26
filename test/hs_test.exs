defmodule HsTest do
  use ExUnit.Case

  test "no questions" do
    assert {:ok, _tx_id, "851712"} = HS.describe_product("iphone")
  end

  test "one questions" do
    assert {:question, tx_id, int_id, question} = HS.describe_product("spoon")
    assert {:ok, _tx_id, "950790"}              = HS.answer_question(tx_id, int_id, %{"artificial bait" => question["artificial bait"]})
  end

  test "multiple questions" do
    assert {:question, tx_id, int_id, question} = HS.describe_product("spoon")
    assert {:question, tx_id, int_id, question} = HS.answer_question(tx_id, int_id, %{"kitchen or table utensil" => question["kitchen or table utensil"]})
    assert {:question, tx_id, int_id, question} = HS.answer_question(tx_id, int_id, %{"base metal" => question["base metal"]})
    assert {:ok, _tx_id, "821599"}               = HS.answer_question(tx_id, int_id, %{"other" => question["other"]})
  end
end
