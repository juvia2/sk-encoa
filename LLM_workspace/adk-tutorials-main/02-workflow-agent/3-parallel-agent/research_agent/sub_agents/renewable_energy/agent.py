from google.adk.agents import LlmAgent
from google.adk.models.lite_llm import LiteLlm
from research_agent.tools.web_search import openai_web_search

renewable_energy_agent = LlmAgent(
    name="renewable_energy_agent",

    model=LiteLlm(
        model="openai/gpt-4o-mini"
    ),

    description="재생 가능 에너지 소스 연구 에이전트",

    instruction="""
당신은 재생 가능 에너지 분야의 AI 연구 보조입니다.

'재생 에너지 소스'의 최신 발전 동향을 조사하세요.

핵심 발견 내용을 간결하게 1~2문장으로 요약하고,
요약만 출력하세요.
""",

   tools=[
        openai_web_search
    ],

    output_key="renewable_energy_result",
)