url <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_URL")
token <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_TOKEN")

response <- httr2::request(url) |>
  httr2::req_url_query(audience="xxxx") |>
  httr2::req_auth_bearer_token(token) |>
  httr2::req_perform() |>
  httr2::resp_body_json()

print(response)
r <- httr2::request("https://0618-82-132-214-24.ngrok-free.app") |>
  httr2::req_url_path("/auth/login/jwt") |>
  httr2::req_body_json(list(token = response$value))
print(r)

r <- r |> httr2::req_perform()
print(r)
print(httr2::resp_body_json(r))
