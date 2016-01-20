# Anonymous function used to add two integers
# The dot is used to invoke an anonymous function
#
#
anonymous_function = fn a, b -> a + b end

IO.puts anonymous_function.(1,2)

# A linked list data  Type
#
#
IO.inspect [ 1, 2, 3 ] ++ [ 3, 4, 5]

# A tuple data Type
#
#

IO.puts Enum.join(Tuple.to_list({ :hello, "goodbye", :there_we_go }))
foobar = { :hello, "goodbye", :there_we_go } |> Tuple.to_list |> Enum.join " "
IO.puts foobar

# The difference between a Tuple and a List is that a Tuple is a contiguous
# section in memory and a list is a linked set of elements. Referencing an
# element in a tuple is computationally efficient because it is referencing it
# by index but changing it requires copying the entire tuple in memory.

# Pattern matching
#
# The '=' operator is not an assignment operator; it matches based on a pattern.
#
# This example represents pattern matching on results
IO.inspect { :ok, result } = { :ok, 'here is your content' }
IO.inspect { :error, message } = { :error, '404 not found' }
IO.inspect { :error, message } = { :error, '401 not authorized' }

# You cannot pattern match on conflicting types
# [a, b] = {a, b} <= Does not match due to the left hand expression being a list
IO.inspect [ a, b ] = [ 1, 2 ]

# The '^' pin operator helps protect against rebinding a variable
# If the right hand expressions second element was anything other than a 1
# then this would error out
x = 1
IO.inspect { y, ^x } = { 1, 1 }

# Case, cond, if
# A case, condition, and if are control flow blocks
#
#

# A case is used to compare a value against multiple patterns
#
# On the case of a match, execute block
#
#
case { 1, 2, 3 } do
  { 4, 5, 6 } ->
    IO.puts "This totally won't match."
  { 1, x, 3 } ->
    IO.puts "This will match and X will be bound to 2"
  _ ->
    IO.puts "This clause will adopt any value but part of a later sequence"
end

# In order to pattern match against an existing variable, use the pin operator
#
#
f = 1
case 10 do
  ^f -> IO.puts "wont match"
  _ -> IO.puts "catch all matcher"
end

# A condition is similar to if/else structures in imperative languages
#
# A sequence of conditions will be evaluated and the first one that rings true
# will proc an anonymous function
#
#
cond do
  2 + 2 == 5 ->
    IO.puts "This will not be evaluated"
  3 + 3 == 6 ->
    IO.puts "This will be evaluated"
  true ->
    IO.puts "This is always evaluated"
end

# Eh, if is boring
#
#
if true do
  IO.puts "This is true"
end

# do blocks are somewhat interesting
#
# As a note, however, do blocks are bound to the outermost function call
#
# This requires computation to be enclosed in parentheses
#
#
if true, do: (IO.puts "this"), else: (IO.puts "that")

# Difference between single and double quotes
#
# A single quoted value is a list of characters and double quotes is of the
# binary types
#
#

# keyword lists and map structures
#
# A keyword list and map are both very similar
#
# A KW list is a list of two value tuples and are often used to handle function
# arguments within Erlang
#
# Keys must be atoms.
# Keys are ordered, as specified by the developer.
# Keys can be given more than once.
#
# A map is analagous to a hash structure in Ruby and is a key value store
#
#
kw_list = [{ :a, 1 }, { :b, 2 }]
IO.puts kw_list[:a]

# Anyway, keyword lists are boring and maps are more interesting
#
# There are two ways to access a map: strict and dynamic
#
# a_map.a
# a_map[:a]
#
#
a_map = %{ :a => "foobarmap", :b => 2 }
IO.puts a_map[:a]
IO.inspect %{ a_map | :a => "digbarmap" }
# Created a new map but didnt' update the old
IO.puts a_map.a

defmodule TokenExample do
  def get_token(string) do
    parts = String.split(string, "&")
    Enum.find_value(parts, fn pair ->
      [key, value] = String.split(pair, "=")
      key == "token" && value
    end)
  end
end

IO.inspect(TokenExample.get_token "token=wackamole&goodbye=fell")
TokenExample.get_token("token=wackamole&hello=foobar&goodbye=foobar") |> IO.inspect

# Even shorter functions!
#
#
# Compiles down to fn x -> x + 1
# & represents a function and &1 represents the first argument to that function
#
#
fun = &(&1+1)
IO.inspect fun.(1)

# Default arguments
#
#
defmodule DefaultArgument do
  def stuff(x \\ IO.puts "i am a default argument") do
    x
  end
end

DefaultArgument.stuff

defmodule Recursion do
  def print_multiple_times(msg, n) when n <= 1 do
    IO.puts msg
  end

  def print_multiple_times(msg, n) do
    IO.puts msg
    print_multiple_times(msg, n - 1)
  end
end

Recursion.print_multiple_times("Hello!", 3)
