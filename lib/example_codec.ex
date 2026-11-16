# User-owned LawSpec adapter. Implement these functions.
defmodule Example.Codec do
  @spec itoa(-2_147_483_648..2_147_483_647) :: binary()

  def itoa(_int32) do
    raise "Not implemented: example.codec::itoa"
  end

  @spec atoi(binary()) :: -2_147_483_648..2_147_483_647

  def atoi(_text) do
    raise "Not implemented: example.codec::atoi"
  end
end
