defmodule Parrot.ApplicationTest do
  use Parrot.DataCase

  alias Parrot.Application

  describe "assistants" do
    alias Parrot.Application.Assistant

    @valid_attrs %{app_id: "some app_id", app_secret: "some app_secret", webhook: "some webhook"}
    @update_attrs %{app_id: "some updated app_id", app_secret: "some updated app_secret", webhook: "some updated webhook"}
    @invalid_attrs %{app_id: nil, app_secret: nil, webhook: nil}

    def assistant_fixture(attrs \\ %{}) do
      {:ok, assistant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Application.create_assistant()

      assistant
    end

    test "list_assistants/0 returns all assistants" do
      assistant = assistant_fixture()
      assert Application.list_assistants() == [assistant]
    end

    test "get_assistant!/1 returns the assistant with given id" do
      assistant = assistant_fixture()
      assert Application.get_assistant!(assistant.id) == assistant
    end

    test "create_assistant/1 with valid data creates a assistant" do
      assert {:ok, %Assistant{} = assistant} = Application.create_assistant(@valid_attrs)
      assert assistant.app_id == "some app_id"
      assert assistant.app_secret == "some app_secret"
      assert assistant.webhook == "some webhook"
    end

    test "create_assistant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Application.create_assistant(@invalid_attrs)
    end

    test "update_assistant/2 with valid data updates the assistant" do
      assistant = assistant_fixture()
      assert {:ok, assistant} = Application.update_assistant(assistant, @update_attrs)
      assert %Assistant{} = assistant
      assert assistant.app_id == "some updated app_id"
      assert assistant.app_secret == "some updated app_secret"
      assert assistant.webhook == "some updated webhook"
    end

    test "update_assistant/2 with invalid data returns error changeset" do
      assistant = assistant_fixture()
      assert {:error, %Ecto.Changeset{}} = Application.update_assistant(assistant, @invalid_attrs)
      assert assistant == Application.get_assistant!(assistant.id)
    end

    test "delete_assistant/1 deletes the assistant" do
      assistant = assistant_fixture()
      assert {:ok, %Assistant{}} = Application.delete_assistant(assistant)
      assert_raise Ecto.NoResultsError, fn -> Application.get_assistant!(assistant.id) end
    end

    test "change_assistant/1 returns a assistant changeset" do
      assistant = assistant_fixture()
      assert %Ecto.Changeset{} = Application.change_assistant(assistant)
    end
  end
end
