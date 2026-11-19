# User-owned LawSpec adapter. Implement these functions.
defmodule Example.Codec do
  @spec itoa(-2_147_483_648..2_147_483_647) :: binary()

  def itoa(int32) do
    Integer.to_string(int32)
  end

  @spec atoi(binary()) :: -2_147_483_648..2_147_483_647

  def atoi(text) do
    String.to_integer(text)
  end
end
