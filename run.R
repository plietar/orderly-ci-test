get_packit_audience <- function(base_url) {
  print(httr2::request(base_url) |> httr2::req_url_path("packit/api/auth/login/service/audience"))
  response <- httr2::request(base_url) |>
    httr2::req_url_path("packit/api/auth/login/service/audience") |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  response$audience
}

get_oidc_token <- function(audience) {
  url <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_URL")
  token <- Sys.getenv("ACTIONS_ID_TOKEN_REQUEST_TOKEN")

  response <- httr2::request(url) |>
    httr2::req_url_query(audience=audience) |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  response$value
}

get_packit_token <- function(base_url, token) {
  response <- httr2::request(base_url) |>
    httr2::req_url_path("packit/api/auth/login/service") |>
    httr2::req_body_json(list(token = token)) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  response$token
}

PACKIT_URL <- "https://packit.dide.ic.ac.uk/reside"

audience <- get_packit_audience(PACKIT_URL)
github_token <- get_oidc_token(audience)
packit_token <- get_packit_token(PACKIT_URL, github_token)

orderly2::orderly_init(force = TRUE)
orderly2::orderly_location_add(
  "packit",
  "packit",
  list(url = PACKIT_URL, token = packit_token))

orderly2::orderly_location_pull_metadata()
id <- orderly2::orderly_run("data")
orderly2::orderly_location_push(id, "packit")
