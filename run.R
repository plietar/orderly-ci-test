url <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_URL")
token <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_TOKEN")

r <- httr2::request(url)
print(r)
r <- r |> httr2::req_url_query(audience="xxxx") |> httr2::req_auth_bearer_token(token)
print(r)
r <- r |> httr2::req_perform()
print(r)
oidc_token <- httr2::resp_body_json()$token

r <- httr2::request("https://0618-82-132-214-24.ngrok-free.app") |>
  httr2::req_url_path("/auth/jwt") |>
  httr2::req_body_json(list(token = oidc_token))

r <- r |> httr2::req_perform()
print(r)
print(httr2::resp_body_json(r))
