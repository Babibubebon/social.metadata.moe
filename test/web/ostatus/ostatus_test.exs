defmodule Pleroma.Web.OStatusTest do
  use Pleroma.DataCase
  alias Pleroma.Web.OStatus

  test "handle incoming notes" do
    incoming = File.read!("test/fixtures/incoming_note_activity.xml")
    {:ok, activity} = OStatus.handle_incoming(incoming)

    assert activity.data["type"] == "Create"
    assert activity.data["object"]["type"] == "Note"
    assert activity.data["published"] == "2017-04-23T14:51:03+00:00"
  end

  describe "new remote user creation" do
    test "make new user or find them based on an 'author' xml doc" do
      incoming = File.read!("test/fixtures/user_name_only.xml")
      {doc, _rest} = :xmerl_scan.string(to_charlist(incoming))

      {:ok, user} = OStatus.find_or_make_user(doc)

      assert user.name == "lambda"
      assert user.nickname == "lambda"
      assert user.local == false
      assert user.info["ostatus_uri"] == "http://gs.example.org:4040/index.php/user/1"
      assert user.info["system"] == "ostatus"
      assert user.ap_id == "http://gs.example.org:4040/index.php/user/1"

      {:ok, user_again} = OStatus.find_or_make_user(doc)

      assert user == user_again
    end

    test "tries to use the information in poco fields" do
      incoming = File.read!("test/fixtures/user_full.xml")
      {doc, _rest} = :xmerl_scan.string(to_charlist(incoming))

      {:ok, user} = OStatus.find_or_make_user(doc)

      assert user.name == "Constance Variable"
      assert user.nickname == "lambadalambda"
      assert user.local == false
      assert user.info["ostatus_uri"] == "http://gs.example.org:4040/index.php/user/1"
      assert user.info["system"] == "ostatus"
      assert user.ap_id == "http://gs.example.org:4040/index.php/user/1"

      assert List.first(user.avatar["url"])["href"] == "http://gs.example.org:4040/theme/neo-gnu/default-avatar-profile.png"

      {:ok, user_again} = OStatus.find_or_make_user(doc)

      assert user == user_again
    end
  end
end
