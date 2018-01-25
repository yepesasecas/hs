# Hs
HS permite obtener el HS6 de tus productos con la descripcion.

## Example

```
{:ok, id, hs6} = HS.describe_product("spoon")
{:question, id, question} = HS.describe_product("spoon")
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
