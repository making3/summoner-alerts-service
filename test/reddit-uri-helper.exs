defmodule RedditUriHelperTest do
  use ExUnit.Case
  doctest RedditUriHelper

  test "get_sticky/1 sets a default num" do
    assert RedditUriHelper.get_sticky("test") == "/r/test/sticky?num=1"
  end

  test "get_sticky/2 sets a given num" do
    assert RedditUriHelper.get_sticky("test", 1) == "/r/test/sticky?num=1"
    assert RedditUriHelper.get_sticky("test", 2) == "/r/test/sticky?num=2"
  end

  test "get_sticky/2 can't be greater than 2" do
    assert_raise ArgumentError, fn -> 
      RedditUriHelper.get_sticky("test", 3)
    end
  end

  test "get_sticky/2 can't be less than 1" do
    assert_raise ArgumentError, fn -> 
      RedditUriHelper.get_sticky("test", 0)
    end

    assert_raise ArgumentError, fn -> 
      RedditUriHelper.get_sticky("test", -1)
    end
  end
end
