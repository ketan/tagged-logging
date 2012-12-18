require 'test_helper'
require 'tagged_logging/formatter'
require 'tagged_logging/blank_ext'

class LoggerTest < Test::Unit::TestCase

  setup do
    @output = StringIO.new
    @logger = TaggedLogging.new(::Logger.new(@output))
    @logger.flush
  end

  test "tagged once" do
    @logger.tagged("BCX") { @logger.info "Funky time" }
    assert_match "INFO  - [BCX] - Funky time\n", @output.string
  end

  test "tagged twice" do
    @logger.tagged("BCX") { @logger.tagged("Jason") { @logger.info "Funky time" } }
    assert_match "INFO  - [BCX] [Jason] - Funky time\n", @output.string
  end

  test "tagged thrice at once" do
    @logger.tagged("BCX", "Jason", "New") { @logger.info "Funky time" }
    assert_match "INFO  - [BCX] [Jason] [New] - Funky time", @output.string
  end

  test "tagged are flattened" do
    @logger.tagged("BCX", %w(Jason New)) { @logger.info "Funky time" }
    assert_match "[BCX] [Jason] [New] - Funky time", @output.string
  end

  test "provides access to the logger instance" do
    @logger.tagged("BCX") { |logger| logger.info "Funky time" }
    assert_match "[BCX] - Funky time", @output.string
  end

  test "push and pop tags directly" do
    assert_equal %w(A B C), @logger.push_tags('A', ['B', '  ', ['C']])
    @logger.info 'a'
    assert_equal %w(C), @logger.pop_tags
    @logger.info 'b'
    assert_equal %w(B), @logger.pop_tags(1)
    @logger.info 'c'
    assert_equal [], @logger.clear_tags!
    @logger.info 'd'

    assert_match "INFO  - [A] [B] [C] - a", @output.string
    assert_match "INFO  - [A] [B] - b", @output.string
    assert_match "INFO  - [A] - c", @output.string
    assert_match "INFO  -  - d", @output.string
  end

  test "does not strip message content" do
    @logger.info " \t\t Hello"
    assert_match "INFO  -  -  \t\t Hello\n", @output.string
  end

  test "tagged once with blank and nil" do
    @logger.tagged(nil, "", "New") { @logger.info "Funky time" }
    assert_match "INFO  - [New] - Funky time", @output.string
  end

  test "keeps each tag in their own thread" do
    @logger.tagged("BCX") do
      Thread.new do
        @logger.tagged("OMG") { @logger.info "Cool story bro" }
      end.join
      @logger.info "Funky time"
    end
    assert_match "INFO  - [OMG] - Cool story bro", @output.string
    assert_match "INFO  - [BCX] - Funky time\n", @output.string
  end

  test "cleans up the taggings on flush" do
    @logger.tagged("BCX") do
      Thread.new do
        @logger.tagged("OMG") do
          @logger.flush
          @logger.info "Cool story bro"
        end
      end.join
    end
    assert_match "INFO  -  - Cool story bro", @output.string
  end

  test "mixed levels of tagging" do
    @logger.tagged("BCX") do
      @logger.tagged("Jason") { @logger.info "Funky time" }
      @logger.info "Junky time!"
    end

    assert_match "INFO  - [BCX] [Jason] - Funky time", @output.string
    assert_match "INFO  - [BCX] - Junky time!", @output.string
  end

end
