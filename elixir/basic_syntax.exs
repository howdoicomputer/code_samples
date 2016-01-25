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

# Recursion in Elixir is heavily based of pattern matching and the
# idea of using a base case to stop the recursion.
#
# In the first example, the first clause in the recursion module is
# using a guard to determine when to stop recursion. When the n
# parameter is less than or equal to 1 then the first declaration of
# print_multiple_times prints the msg paramter and finishes
# execution.
#
# Because the first declaration of print_multiple_times matched the
# pattern passed into it via parameters, Elixir has no reason to
# evaulaute the second clause. The first clause is known as the
# base case.
#
# With the second example, the base case is the second declaration
# as that matches against an empty list in order to return the
# accumulator variable.
#
# The first clause in the Math module is what will do the heavy work
# - taking the head and tail of the list, adding the head to an
# accumulator variable and passing the tail to self as a list to the
# first paramenter.
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

defmodule Math do
  def sum_list([head|tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end
end

IO.inspect Math.sum_list([1, 2, 3], 0)

# For list operations it is not likely that recursion is needed.
# A call to the Enum module is more syntactically clear.

Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end)

# The initial docs aren't clear on the &+/ syntax. I think what it
# does is create an anonymous function adds the first two ar
#
#
Enum.reduce([1, 2, 3], 0, &+/2)

# Remember the anonymous function shorthand? The Enum.map/2 function
# is taking in the function_declaration(first_argument * n).
#
#
Enum.map([1, 2, 3], &(&1 * 2)) |> IO.inspect
Enum.map([1, 2, 3], fn(x) -> x * 2 end)

# The Enum.map/2 function with key/value and range examples
#
#
Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end)
Enum.map(1..3, fn x -> x * 2 end)

# Every function in the Enum module is eager so that its results
# can be passed as intermediate lists following the pipe |> operator
#
# The below example takes a large range, pipes to the map function
# where it every element is multiplied by 3, then that list is
# piped to a filter function that takes all odd numbers, then that
# list is piped to a the sum function that sums all the elements.
#
#
odd? = &(rem(&1, 2) != 0)
1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum

# To achieve lazily evaluated operations on enumerables then the
# Stream module is your huckleberry
#
1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?)

# The above will produce a Stream - which can be evaulated
