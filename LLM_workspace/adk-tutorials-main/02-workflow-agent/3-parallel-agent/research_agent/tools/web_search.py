from openai import OpenAI


client = OpenAI()


def openai_web_search(query: str) -> str:
    """
    OpenAI Web Search를 이용하여 인터넷에서 최신 정보를 검색한다.

    Args:
        query: 검색할 검색어

    Returns:
        검색 결과 텍스트
    """

    try:
        response = client.responses.create(
            model="gpt-4o-mini",
            tools=[
                {
                    "type": "web_search"
                }
            ],
            input=query,
        )

        return response.output_text

    except Exception as e:
        return f"웹 검색 중 오류가 발생했습니다: {e}"