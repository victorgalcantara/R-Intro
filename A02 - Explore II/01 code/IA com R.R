# Script para experimentar IA com R
# por Victor G Alcantara, São Paulo, 2024

# 0. Setup ----

library(pacman)
p_load(tidyverse,rio,openai,pak)

pak::pak("moodymudskipper/ask")

askgpt::askgpt(prompt = "Qual a frase mais usada para iniciantes em programação?")

# Open AI

# 1 - Create an API from openAI
# https://platform.openai.com/api-keys

# 2 - Register your API as environment variable in your terminal (PowerShell)
# setx OPENAI_API_KEY "your_api_key_here"

# 3 - Register your API here
Sys.setenv(
  OPENAI_API_KEY = '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'
)

create_completion(
  model = "gpt-4o-mini",
  prompt = "Qual a frase mais usada para iniciantes em programação?"
)

openai::create_image(prompt = "An astronaut riding a horse in a photorealistic style")

