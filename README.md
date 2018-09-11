# HS
HS6 Classification Tool.

## Example

### No Questions Classification

```elixir
iex> HS.describe_product("iphone")
{:ok, _tx_id, "851712"}
```

### Multi Question Classification

```elixir
iex> HS.describe_product("spoon")
{:question, tx_id, interaction_id, [%{
      "name" => "artificial bait",
      "id" => "3d2c8946-dcfc-44a3-b87c-5d34b25246e6"
    }, %{
      "name" => "hand tool",
      "id" => "c0a3aaeb-c51e-4c67-b88a-660b87f2b26e"
    }, %{
      "name" => "kitchen or table utensil",
      "id" =>  "4fdb7e01-a09f-436d-9aa2-24839ee903f2"
    }
  ]
}

iex> HS.answer_question(tx_id, transaction_id, [%{"name"=> "artificial bait", "id" => "3d2c8946-dcfc-44a3-b87c-5d34b25246e6"}])
{:ok, _tx_id, "950790"}
```
