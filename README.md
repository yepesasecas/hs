# HS
HS6 Classification Tool.

## Example

### No Questions Classification

```elixir
iex> HS.describe_product("iphone")
{:ok, "xxx", "851712"}
```

### Multi Question Classification

```elixir
iex> HS.describe_product("spoon")
{:question, "xxx", "xxx123", %{"artificial bait" => "3d2c8946-dcfc-44a3-b87c-5d34b25246e6", "hand tool" => "c0a3aaeb-c51e-4c67-b88a-660b87f2b26e", "kitchen or table utensil" => "4fdb7e01-a09f-436d-9aa2-24839ee903f2"}}

iex> HS.answer_question("xxx", "xxx123", %{"artificial bait" => "3d2c8946-dcfc-44a3-b87c-5d34b25246e6"})
{:ok, "xxx", "950790"}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hs](https://hexdocs.pm/hs).
