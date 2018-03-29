defmodule Parrot.CustomersTest do
  use Parrot.DataCase

  alias Parrot.Customers

  describe "integrations" do
    alias Parrot.Customers.Integration

    @valid_attrs %{app_id: "some app_id", app_secret: "some app_secret", integration_endpoint: "some integration_endpoint"}
    @update_attrs %{app_id: "some updated app_id", app_secret: "some updated app_secret", integration_endpoint: "some updated integration_endpoint"}
    @invalid_attrs %{app_id: nil, app_secret: nil, integration_endpoint: nil}

    def integration_fixture(attrs \\ %{}) do
      {:ok, integration} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_integration()

      integration
    end

    test "list_integrations/0 returns all integrations" do
      integration = integration_fixture()
      assert Customers.list_integrations() == [integration]
    end

    test "get_integration!/1 returns the integration with given id" do
      integration = integration_fixture()
      assert Customers.get_integration!(integration.id) == integration
    end

    test "create_integration/1 with valid data creates a integration" do
      assert {:ok, %Integration{} = integration} = Customers.create_integration(@valid_attrs)
      assert integration.app_id == "some app_id"
      assert integration.app_secret == "some app_secret"
      assert integration.integration_endpoint == "some integration_endpoint"
    end

    test "create_integration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_integration(@invalid_attrs)
    end

    test "update_integration/2 with valid data updates the integration" do
      integration = integration_fixture()
      assert {:ok, integration} = Customers.update_integration(integration, @update_attrs)
      assert %Integration{} = integration
      assert integration.app_id == "some updated app_id"
      assert integration.app_secret == "some updated app_secret"
      assert integration.integration_endpoint == "some updated integration_endpoint"
    end

    test "update_integration/2 with invalid data returns error changeset" do
      integration = integration_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_integration(integration, @invalid_attrs)
      assert integration == Customers.get_integration!(integration.id)
    end

    test "delete_integration/1 deletes the integration" do
      integration = integration_fixture()
      assert {:ok, %Integration{}} = Customers.delete_integration(integration)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_integration!(integration.id) end
    end

    test "change_integration/1 returns a integration changeset" do
      integration = integration_fixture()
      assert %Ecto.Changeset{} = Customers.change_integration(integration)
    end
  end
end
