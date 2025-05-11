
client GPT4 {
    provider openai
    options {
        model gpt-4o-mini
        api_key env.OPENAI_API_KEY
    }
}

client<llm> DeepSeekR1 {
  provider openai-generic
  options {
    base_url "https://api.together.ai/v1"
    api_key env.TOGETHER_API_KEY
    model "deepseek-ai/DeepSeek-R1-Distill-Llama-70B-free"
  }
}

function ExtractPerson(info: string) -> Person {
    client GPT4
    prompt #"
        {{ ctx.output_format }}

        Extract the person's information from the following string:
        {{ info }}
    "#
}

class Person {
    name string
    age int
}

function DescribeImage(myImg: image) -> string {
  client GPT4
  prompt #"
    {{ _.role("user")}}
    Describe the image in four words:
    {{ myImg }}
  "#
}

enum Model {
  DeepSeekR1
  GPT4oMini
}

function WhichModel() -> Model {
    client GPT4
    prompt #"
        Which model are you?

        {{ ctx.output_format }}
    "#
}