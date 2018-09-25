defmodule ReactRender.Test do
  use ExUnit.Case
  doctest ReactRender

  setup_all do
    apply(ReactRender, :start_link, [[render_service_path: "./priv/server.js"]])
    :ok
  end

  describe "get_html" do
    test "returns html" do
      {:ok, html} = ReactRender.get_html("./HelloWorld.js", %{name: "test"})
      assert html =~ "<div data-reactroot=\"\">Hello"
      assert html =~ "test</div>"
    end

    test "returns error when no component found" do
      {:error, error} = ReactRender.get_html("./NotFound.js")
      assert error.message =~ "Cannot find module"
    end
  end

  describe "render" do
    test "returns html" do
      {:safe, html} = ReactRender.render("./HelloWorld.js", %{name: "test"})
      assert html =~ "data-rendered"
      assert html =~ "data-component"
      assert html =~ "HelloWorld"
      assert html =~ "<div data-reactroot=\"\">Hello"
      assert html =~ "test</div>"
    end

    test "raises RenderError when no component found" do
      assert_raise ReactRender.RenderError, "Cannot find module './NotFound.js'", fn ->
        ReactRender.render("./NotFound.js")
      end
    end
  end
end
