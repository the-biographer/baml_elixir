
client GPT4 {
    provider openai
    options {
        model gpt-4o-mini
        api_key env.OPENAI_API_KEY
    }
}

client DeepSeekR1 {
  provider openai-generic
  options {
    base_url "https://api.together.ai/v1"
    api_key env.TOGETHER_API_KEY
    model "deepseek-ai/DeepSeek-R1-Distill-Llama-70B-free"
  }
}

client Claude35Sonnet {
    provider anthropic
    options {
        model claude-3-5-sonnet-latest
        api_key env.ANTHROPIC_API_KEY
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

class DummyOutput {
  nonce string
  nonce2 string
}

function DummyOutputFunction() -> DummyOutput {
  client GPT4
  prompt #"
    Say "hello there".
  "#
}

class Attendees {
  hosts Person[]
  guests Person[]
}

function ParseAttendees(attendees: string) -> Attendees {
  client GPT4
  prompt #"
    {{ ctx.output_format }}

    Parse the following string into an Attendees struct:
    {{ attendees }}
  "#
}