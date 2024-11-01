defmodule LiveViewNativeTest.ComponentTest do
  use ExUnit.Case

  import LiveViewNative.LiveForm.Component
  import LiveViewNative.Component, only: [sigil_LVN: 2]
  import LiveViewNative.Template.Parser, only: [parse_document!: 1]

  defmacro sigil_X({:<<>>, _, [binary]}, []) when is_binary(binary) do
    Macro.escape(parse_sorted!(binary))
  end

  defmacro sigil_x(term, []) do
    quote do
      unquote(__MODULE__).parse_sorted!(unquote(term))
    end
  end

  def t2h(template) do
    template
    |> Phoenix.LiveViewTest.rendered_to_string()
    |> parse_sorted!()
  end

  @doc """
  Parses LVN templates into Floki format with sorted attributes.
  """
  def parse_sorted!(value) do
    value
    |> parse_document!()
    |> Enum.map(&normalize_attribute_order/1)
  end

  defp normalize_attribute_order({node_type, attributes, content}),
    do: {node_type, Enum.sort(attributes), Enum.map(content, &normalize_attribute_order/1)}

  defp normalize_attribute_order(values) when is_list(values),
    do: Enum.map(values, &normalize_attribute_order/1)

  defp normalize_attribute_order(value), do: value

  describe "to_form/2" do
    test "with a map" do
      form = to_form(%{})
      assert form.name == nil
      assert form.id == nil

      form = to_form(%{}, as: :foo)
      assert form.name == "foo"
      assert form.id == "foo"

      form = to_form(%{}, as: :foo, id: "bar")
      assert form.name == "foo"
      assert form.id == "bar"

      form = to_form(%{}, custom: "attr")
      assert form.options == [custom: "attr"]

      form = to_form(%{}, errors: [name: "can't be blank"])
      assert form.errors == [name: "can't be blank"]
    end

    test "with a form" do
      base = to_form(%{}, as: "name", id: "id")
      assert to_form(base, []) == base

      form = to_form(base, as: :foo)
      assert form.name == "foo"
      assert form.id == "foo"

      form = to_form(base, id: "bar")
      assert form.name == "name"
      assert form.id == "bar"

      form = to_form(base, as: :foo, id: "bar")
      assert form.name == "foo"
      assert form.id == "bar"

      form = to_form(base, as: nil, id: nil)
      assert form.name == nil
      assert form.id == nil

      form = to_form(base, custom: "attr")
      assert form.options[:custom] == "attr"

      form = to_form(base, errors: [name: "can't be blank"])
      assert form.errors == [name: "can't be blank"]

      # uncomment with Phoenix LiveView 1.0 is released
      # form = to_form(base, action: :validate)
      # assert form.action == :validate
    end
  end

  test "used_input?/1" do
    params = %{}
    form = to_form(params, as: "profile", action: :validate)
    refute used_input?(form[:username])
    refute used_input?(form[:email])

    params = %{"username" => "", "email" => ""}
    form = to_form(params, as: "profile", action: :validate)
    assert used_input?(form[:username])
    assert used_input?(form[:email])

    params = %{"username" => "", "email" => "", "_unused_username" => ""}
    form = to_form(params, as: "profile", action: :validate)
    refute used_input?(form[:username])
    assert used_input?(form[:email])

    params = %{"username" => "", "email" => "", "_unused_username" => "", "_unused_email" => ""}
    form = to_form(params, as: "profile", action: :validate)
    refute used_input?(form[:username])
    refute used_input?(form[:email])
  end

  describe "inputs_for" do
    test "generates nested inputs with no options" do
      assigns = %{}

      template = ~LVN"""
        <.form :let={f} as={:myform}>
          <.inputs_for :let={finner} field={f[:inner]} }>
            <% 0 = finner.index %>
            <Input id={finner[:foo].id} name={finner[:foo].name} type="text" />
          </.inputs_for>
        </.form>
        """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <LiveHiddenField name="myform[inner][_persistent_id]" value="0" />
          <Input id="myform_inner_0_foo" name="myform[inner][foo]" type="text" />
        </LiveForm>
        """
    end

    test "with naming options" do
      assigns = %{}

      template = ~LVN"""
        <.form :let={f} as={:myform}>
          <.inputs_for :let={finner} field={f[:inner]} } id="test" as={:name}>
            <Input id={finner[:foo].id} name={finner[:foo].name} type="text" />
          </.inputs_for>
        </.form>
        """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <LiveHiddenField name="name[_persistent_id]" value="0" />
          <Input id="myform_inner_0_foo" name="name[foo]" type="text" />
        </LiveForm>
        """
    end

    test "with default map option" do
      assigns = %{}

      template = ~LVN"""
        <.form :let={f} as={:myform}>
          <.inputs_for :let={finner} field={f[:inner]} } default={%{foo: "123"}}>
            <Input id={finner[:foo].id} name={finner[:foo].name} type="text" value={finner[:foo].value} />
          </.inputs_for>
        </.form>
        """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <LiveHiddenField name="myform[inner][_persistent_id]" value="0" />
          <Input id="myform_inner_0_foo" name="myform[inner][foo]" type="text" value="123" />
        </LiveForm>
        """
    end

    test "with default list and list related options" do
      assigns = %{}

      template = ~LVN"""
      <.form :let={f} as={:myform}>
        <.inputs_for
          :let={finner}
          field={f[:inner]}
          }
          default={[%{foo: "456"}]}
          prepend={[%{foo: "123"}]}
          append={[%{foo: "789"}]}
        >
          <Input id={finner[:foo].id} name={finner[:foo].name} type="text" value={finner[:foo].value} />
        </.inputs_for>
      </.form>
      """

      assert t2h(template) ==
        ~X"""
        <LiveForm>
          <LiveHiddenField name="myform[inner][0][_persistent_id]" value="0" />
          <Input id="myform_inner_0_foo" name="myform[inner][0][foo]" type="text" value="123" />
          <LiveHiddenField name="myform[inner][1][_persistent_id]" value="1" />
          <Input id="myform_inner_1_foo" name="myform[inner][1][foo]" type="text" value="456" />
          <LiveHiddenField name="myform[inner][2][_persistent_id]" value="2" />
          <Input id="myform_inner_2_foo" name="myform[inner][2][foo]" type="text" value="789" />
        </LiveForm>
        """
end

    test "with FormData implementation options" do
      assigns = %{}

      template = ~LVN"""
      <.form :let={f} as={:myform}>
        <.inputs_for :let={finner} field={f[:inner]} } options={[foo: "bar"]}>
          <Text><%= finner.options[:foo] %></Text>
        </.inputs_for>
      </.form>
      """

      lvn = t2h(template)
      assert [text] = Floki.find(lvn, "Text")
      assert Floki.text(text) =~ "bar"
    end
  end
end
