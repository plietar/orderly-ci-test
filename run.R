url <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_URL")
token <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_TOKEN")

response <- httr2::request(url) |>
  httr2::req_url_query(audience="https://0618-82-132-214-24.ngrok-free.app/packit/api/auth/login/jwt") |>
  httr2::req_auth_bearer_token(token) |>
  httr2::req_perform() |>
  httr2::resp_body_json()

print(response)
r <- httr2::request("https://0618-82-132-214-24.ngrok-free.app/packit/api/auth/login/jwt") |>
  httr2::req_body_json(list(token = response$value)) |>
  httr2::req_perform() |>
  httr2::resp_body_json()

print(r$token)

orderly2::orderly_init(force = TRUE)
orderly2::orderly_location_add(
  "packit",
  "packit",
  list(url = "https://0618-82-132-214-24.ngrok-free.app",
       token = r$token))
orderly2::orderly_location_pull_metadata()
id <- orderly2::orderly_run("data")
orderly2::orderly_location_push(id, "packit")

