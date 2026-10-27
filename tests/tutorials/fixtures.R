# Test inputs for exercises that have a `-check` chunk but no `-solution` chunk.
# Structure: fixtures[[tutorial]][[exercise label]] <- code (a character vector
# holds several alternatives that should all pass).
fixtures <- list(
  "00-learnr" = list(
    addition = "25 / 7"
  ),
  "01-intro" = list(
    addition = "5 + 7",
    subtraction = "10 - 3",
    multiplication = "3 * 7",
    division = "12 / 4"
  ),
  "02-vectors" = list(
    `cm-convert` = "length_cm / 2.54",
    `make-char-vec` = "c(\"a\", \"b\")",
    `make-log-vec` = "c(TRUE, FALSE)",
    `fruits-type` = "typeof(fruits)",
    `length-cm-type` = "typeof(length_cm)",
    `seq-args` = c("seq(from = 1, to = 99, by = 2)", "seq(1, 99, 2)")
  ),
  "03-load" = list(
    chickens = "chickens <- read_csv(readr_example(\"chickens.csv\"))\nchickens",
    `read-csv-url` = "sales <- read_csv(\"https://pos.it/r4ds-01-sales\")\nsales"
  ),
  "04-tidy-1" = list(
    `rename-gapminder` = "gapminder <- janitor::clean_names(gapminder_raw)\ngapminder",
    `arrange-life-exp` = "arrange(gapminder, life_exp)",
    `arrange-desc-gdp` = "arrange(gapminder, desc(gdp_percap))",
    `filter-japan` = "filter(gapminder, country == \"Japan\")",
    `filter-japan-taiwan` = "filter(gapminder, country == \"Japan\" | country == \"Taiwan\")",
    `filter-asia-life` = "filter(gapminder, continent == \"Asia\", life_exp < 65, year == 2007)",
    `mutate-pop` = "mutate(gapminder, pop = pop / 10000)",
    `mutate-gdp-percap` = "mutate(gapminder, gdp_percap = gdp_percap * 150)",
    `mutate-gdp` = "mutate(gapminder, gdp = gdp_percap * pop)"
  ),
  "05-tidy-2" = list(
    `mutate-pop-pipe` = "gapminder |> mutate(pop = pop / 10000)",
    `filter-asia-pipe` = "gapminder |> filter(continent == \"Asia\", life_exp < 65, year == 2007)",
    `europe-pipeline` = "gapminder |>\n  filter(year == 1997, continent == \"Europe\") |>\n  mutate(pop = pop / 10000) |>\n  arrange(pop)",
    `group-continent` = "gapminder |>\n  group_by(continent)",
    `mean-gdp-continent` = "gapminder |>\n  group_by(continent) |>\n  summarize(mean_gdp_percap = mean(gdp_percap))",
    `mean-gdp-n-continent` = "gapminder |>\n  group_by(continent) |>\n  summarize(mean_gdp_percap = mean(gdp_percap), n_obs = n())"
  ),
  "06-plot-1" = list(
    `join-sales-menu` = "sales |> left_join(menu)",
    `join-sales-menu-by` = "sales |> left_join(menu, by = join_by(item))",
    `join-sales-ingredient-by` = "menu |> left_join(ingredients, by = join_by(item))",
    `calculate-total` = "sales |>\n  left_join(menu, by = join_by(item)) |>\n  mutate(income_per_item = number_sold * price) |>\n  summarize(grand_total = sum(income_per_item))"
  )
)
