get_packit_audience <- function(base_url) {
  response <- httr2::request(base_url) |>
    httr2::req_url_path_append("packit/api/auth/login/service/audience") |>
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
    httr2::req_url_path_append("packit/api/auth/login/service") |>
    httr2::req_body_json(list(token = token)) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  response$token
}

args = commandArgs(trailingOnly=TRUE)

LOCATION_NAME <- args[[1]]
PACKIT_URL <- args[[2]]

audience <- get_packit_audience(PACKIT_URL)
github_token <- get_oidc_token(audience)
packit_token <- get_packit_token(PACKIT_URL, github_token)

orderly2::orderly_location_add(
  LOCATION_NAME,
  type = "packit",
  args = list(url = PACKIT_URL, token = packit_token))

# TODO: ::add-mask::VALUE
