defmodule Cryptscrape.Email do
  import Bamboo.Email
  alias Cryptscrape.Email

  def welcome_email do
    new_email(
      to: "john@gmail.com",
      from: "support@myapp.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )

    # or pipe using Bamboo.Email functions
    new_email
    |> to("foo@example.com")
    |> from("me@example.com")
    |> subject("Welcome!!!")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
  end


  def welcome_email(email) do
    new_email(
      to: email,
      from: "support@icorumors.io",
      subject: "Welcome to ICORUMORS",
      html_body: "<strong>Thanks for Signing up to ICORUMORS</strong>",
      text_body: "Thanks for joining!"
    )
  end

  def password_recovery(email, password) do
    new_email(
      to: email,
      from: "support@icorumors.io",
      subject: "Password Reset",
      html_body: "<strong>Your password has been reset too: " <> password <> "</strong>",
      text_body: "If this isn't you email us immediately!"
    )
  end
end
